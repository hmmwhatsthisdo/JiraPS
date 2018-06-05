<#
.SYNOPSIS
    Updates the body, visibility, or privacy settings on a Jira comment.
.DESCRIPTION
    This cmdlet updates one or more properties (including body, visibility/privacy, and other settings) on a Jira comment.
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>
function Set-JiraIssueComment {
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = "Medium",
        DefaultParameterSetName = "NoVisibility"
    )]
    param (

        # The comment to be updated. In general, this should be pipelined from Get-JiraIssueComment.
        [Parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [Alias("IssueComment")]
        [PSTypeName("JiraPS.Comment")]
        $Comment,

        # The comment's body.
        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [String]
        $Body,

        # Whether the comment should be internal. Once set as internal, comments cannot be re-set as publicly visible. Use caution when working with this parameter.
        [Parameter()]
        [switch]
        $Internal,

        # The name of the role to restrict visibility to. Users outside of this role will not see the comment.
        [Parameter(
            Mandatory,
            ParameterSetName = "RoleVisibility"
        )]
        [Alias("Role")]
        [string]
        $RestrictToRole,

        # The name of the group to restrict visibility to. Users outside of this group will not see the comment.
        [Parameter(
            Mandatory,
            ParameterSetName = "GroupVisibility"
        )]
        [Alias("Group")]
        [string]
        $RestrictToGroup,

        # Additional properties to be added to the comment, if applicable.
        [Parameter()]
        [ValidateNotNull()]
        [Alias("Properties")]
        [hashtable]
        $AdditionalProperties = @{},

        # Explicit credentials to be used for this request, if required.
        [Parameter()]
        [System.Management.Automation.CredentialAttribute()]
        [pscredential]
        $Credential,

        # Specifies whether the cmdlet should return the object from the Jira API.
        [Parameter()]
        [switch]
        $PassThru

    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
    }

    process {

        $URI = $Comment.RestURL

        Write-Debug "Endpoint URI: $URI"

        # Construct the HT/object to be pushed into the API.
        $CommentUpdateHT = @{
            body = $Body
        }
        If ($PSCmdlet.ParameterSetName -eq "RoleVisibility") {
            Write-Verbose "Restricting comment visibility to role `"$RestrictToRole`"."
            $CommentUpdateHT.visibility = @{
                type = "role"
                value = $RestrictToRole
            }
        } elseif ($PSCmdlet.ParameterSetName -eq "GroupVisibility") {
            Write-Verbose "Restricting comment visibility to group `"$RestrictToGroup`"."
            $CommentUpdateHT.visibility = @{
                type = "group"
                value = $RestrictToGroup
            }
        } Else {
            Write-Verbose "Not specifying visibility changes."
        }

        # Jira uses a strange format for handling comments being internal/external on Jira SD.
        # This construction allows us to specify both the "Internal comment" part and any add'l properties as KVPs.
        If ($Internal.IsPresent) {
            $InternalKVP = @{
                "sd.public.comment" = @{
                    internal = $Internal.ToBool()
                }
            }
        } Else {
            $InternalKVP = @{}
        }

        ($InternalKVP + $AdditionalProperties).GetEnumerator() | ForEach-Object {
            Write-Debug "Attaching KVP $($_.Key) = $($_.Value)"
            Write-Output @{
                key = $_.Key
                value = $_.Value
            }
        } | Set-Variable CommentProperties

        If ($CommentProperties) {
            $CommentUpdateHT.properties = ,$CommentProperties
        }

        Write-Verbose "Invoking Jira API."
        $JiraMethodParameters = @{
            URI = $URI
            Method = "Put"
            Credential = $Credential
            Body = $CommentUpdateHT | ConvertTo-Json -Compress -Depth 100
            RawBody = $true
            Headers = @{
                Referer = $Server
            }
        }

        If ($PSCmdlet.ShouldProcess("Comment $($Comment.ID)","Update Jira Comment")) {
            $Response = Invoke-JiraMethod @JiraMethodParameters | ConvertTo-JiraComment

            If ($PassThru) {
                Write-Output $Response
            }
        }
    }

    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}
