//%attributes = {"executedOnServer":true}


$e_client:=ds:C1482.client.new()
$e_client.name:="i.LEVEL Software"
$e_client.code:="iLEVEL"
$e_client.address:=New object:C1471
$e_client.address.add1:=""
$e_client.address.add2:=""
$e_client.address.town:=""
$e_client.address.county:=""
$e_client.address.postcode:=""
$e_client.address.countryCode:=""

$e_client.detail:=New object:C1471
$e_client.save()


$e_user:=ds:C1482.user.new()
$e_user.fk_record:=$e_client.id
$e_user.tableId:=Table:C252(->[client:1])
$e_user.username:="Tom"
$vt_pass:=NTK HMAC Text(Storage:C1525.namak.prefix+"testing123"; "SHA512"; Storage:C1525.namak.key)
$e_user.password:=$vt_pass
$e_user.email:="tom@ilevelsoftware.co.uk"
$e_user.type:="client"
$e_user.detail:=New object:C1471
$e_user.save()

