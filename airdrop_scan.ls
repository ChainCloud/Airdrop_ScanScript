require! {
	\file-system :fs
	\read-file   :read
	\prelude-ls  :p
	\request     :request
	\sleep       :sleep
}

API-KEY = \GR42RCNKD327X3KWFQJRBJ7QE7ZHZEY4RV

# KickICO
#ADDRESS = \0x3AA5FA4FBF18d19548680a5f2BbA061b18Fed26b

# Credo
ADDRESS = \0x4E0603e2A27A30480E5e3a4Fe548e29EF12F64bE

get-txs-template=-> "http://api.etherscan.io/api?module=account&action=txlist&address=#{it}&startblock=0&endblock=99999999&sort=asc&apikey=#{API-KEY}"

get-addresses-array=(address, cb)-> request get-txs-template(address), (err, res, body)-> 
	if body.0 == \< => return cb \get-addresses-array: + body
	console.log 'Addresses count:' JSON.parse(body).result.length
	JSON.parse(body).result
		|> p.map (.from)
		|> p.unique
		|> -> cb null, it
	
balance-request-template=-> "https://api.etherscan.io/api?module=account&action=balancemulti&address=#{it}&tag=latest&apikey=#{API-KEY}"
balance-form-request=-> balance-request-template p.join \, it

get-non-empty-accounts-array=(address-pack, cb)-> request balance-form-request(address-pack), (err,res,body)->
	if body.0 == \< => return cb \get-non-empty-accounts-array: + body
	JSON.parse(body).result 
		|> p.reject (.balance?length<19)
		|> p.map (.account)
		|> -> cb null, it

(main=-> get-addresses-array ADDRESS, (err, unique-addresses)->
	steps = Math.ceil unique-addresses.length/20
	console.log 'Total steps: ', steps
	n = 1
	address-pack = unique-addresses
	if n!=(steps - 1) => address-pack = address-pack |> p.drop n*20 |> p.take 20

	(cycle=(cb)-> 
		
		address-pack = unique-addresses
		if n!=(steps - 1) => address-pack = address-pack |> p.drop n*20 |> p.take 20
		console.log \cycle: n
		get-non-empty-accounts-array address-pack, (err, arr)->
			if !err		
				n += 1
				console.log 'Non empty from this 20:\n', p.join \\n arr
				fs.appendFileSync 'result.txt', p.join '\n' arr 
				fs.appendFileSync 'result.txt', '\n' 

			if n==(steps)
				console.log \Finished
				return
			else
				sleep.msleep 10 
				cycle(cb)
	)()
)()
