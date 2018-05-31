---
external help file: JiraPS-help.xml
Module Name: JiraPS
online version:
schema: 2.0.0
---

# Set-JiraIssueComment

## SYNOPSIS

Updates the body, visibility, or privacy settings on a Jira comment.

## SYNTAX

### NoVisibility (Default)

```powershell
Set-JiraIssueComment -Comment <Object> [-Body <String>] [-Internal] [-AdditionalProperties <Hashtable>]
 [-Credential <PSCredential>] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### RoleVisibility

```powershell
Set-JiraIssueComment -Comment <Object> [-Body <String>] [-Internal] -RestrictToRole <String>
 [-AdditionalProperties <Hashtable>] [-Credential <PSCredential>] [-PassThru] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### GroupVisibility

```powershell
Set-JiraIssueComment -Comment <Object> [-Body <String>] [-Internal] -RestrictToGroup <String>
 [-AdditionalProperties <Hashtable>] [-Credential <PSCredential>] [-PassThru] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

This cmdlet updates one or more properties (including body, visibility/privacy, and other settings) on a Jira comment.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-JiraIssueComment -ID XYZ-12345 | Set-JiraIssueComment -Internal
```

Make all comments in issue XYZ-12345 internal (not visible to a customer/client)

## PARAMETERS

### -Comment

The comment to be updated.
In general, this should be pipelined from Get-JiraIssueComment.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: IssueComment

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Body

The comment's body.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Internal

Whether the comment should be internal.
Once set as internal, comments cannot be re-set as publicly visible.
Use caution when working with this parameter.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -RestrictToRole

The name of the role to restrict visibility to.
Users outside of this role will not see the comment.

```yaml
Type: String
Parameter Sets: RoleVisibility
Aliases: Role

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RestrictToGroup

The name of the group to restrict visibility to.
Users outside of this group will not see the comment.

```yaml
Type: String
Parameter Sets: GroupVisibility
Aliases: Group

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AdditionalProperties

Additional properties to be added to the comment, if applicable.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases: Properties

Required: False
Position: Named
Default value: @{}
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential

Explicit credentials to be used for this request, if required.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru

Specifies whether the cmdlet should return the object from the Jira API.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf

Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### [JiraPS.Comment]

## OUTPUTS

### [JiraPS.Comment]

If the `-PassThru` parameter is provided,
this function will provide a reference to the JIRA comment modified.
Otherwise, this function does not provide output.

## NOTES

This function requires either the `-Credential` parameter to be passed or a persistent JIRA session.
See `New-JiraSession` for more details.

## RELATED LINKS
