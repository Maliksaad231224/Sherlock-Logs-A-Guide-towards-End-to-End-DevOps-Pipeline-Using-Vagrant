vagrant global-status --prune | Select-String "virtualbox" | ForEach-Object {
    $id = ($_ -split '\s+')[1]
    vagrant destroy -f $id
}