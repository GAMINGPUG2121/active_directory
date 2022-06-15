param( [Parameter(Mandatory=$true)] $JSONFile )

function CreateADGroup(){
    param( [Parameter(Mandatory=$true)] $groupObject )

    $name = $groupObject.name
    New-ADGroup -name $name -GroupScope Global
}



function CreateADUser(){
    param( [Parameter(Mandatory=$true)] $userObject )

    # Pull out the name from the JSON Object
    $name = $userObject.name
    $pasword = $userObject.password


    # Generate a "first initial, last name" structure for username
    $firstname, $lastname = $name.Split(" ")
    $username = ($firstname[0] + $lastname).ToLower()
    $samAcountName = $username
    $principalname = $username


    # Actually create the AD user object
    New-ADUser -Name "$firstname $lastname" -GivenName $firstname -Surname $lastname -SamAccountName $SamAccountName -UserPrincipalName $principalname@$Global:Domain -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -PassThru | Enable-ADAccount


    # Add the user to its appropriate group
    foreach($group_name in $userObject.groups) {
        


        try {
            Get-ADGroup -Identity "$group"
            Add-GroupMember -Identity $group_name - Members $username
        }

        catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
        {
            Write-Warning "User $name NOT added to group $group_name because it does not exist."
        }

    }


        
    echo $userObject
}



$json = ( Get-Content $JSONFile | ConvertFrom-Json)

$Global:Domain = $json.domain


foreach ( $group in $json.groups ){
    CreateADUser $group
}

foreach ( $user in $json.users ){
    CreateADUser $user
}