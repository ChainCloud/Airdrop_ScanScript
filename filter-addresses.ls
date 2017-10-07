require! {
	\file-system :fs
	\read-file   :read
	\prelude-ls  :p
	\request     :request
	\sleep       :sleep
}

API-KEY = \GR42RCNKD327X3KWFQJRBJ7QE7ZHZEY4RV

erc20-contract-names = <[ AdToken Aragon Bancor BAT BCAP Bitquence Civic Cofound DGD DICE district0x Edgeless EOS FirstBlood FunFair Gnosis Golem Guppy Humaniq ICONOMI images KyberNetwork Lunyr Melon Metal MKR Monaco NimiqNetwork Numeraire OmiseGo Pluton Qtum REP RLC SAN SNGLS StatusNetwork Storj SwarmCity TAAS TenXPay TIME TokenCard Trustcoin vSlice WINGS Xaurum ZRX ]>
name-to-address=(name,cb)-> request "https://etherscan.io/token/"+name, (err, res, body)->
	if err=> return cb \name-to-address-err
	cb null, body.replace /[\S\s]+\<\/td\>\n\<td\>\n\<a href=\'\/address\/0x([\S]+)\'\>[\S\s]+/, '0x$1' 

n = 20
get-addresses-cycle=-> name-to-address erc20-contract-names[n], (err,res)->
	console.log res
	n +=1
	sleep.msleep 3000
	get-addresses-cycle!

get-tokens-balance=(contract, address, cb)-> request "https://api.etherscan.io/api?module=account&action=tokenbalance&contractaddress=#{contract}&address=#{address}&tag=latest&apikey=#{API-KEY}", (err,res,body)->
	if err
		console.log \err: err
		return cb err:err

	cb null, JSON.parse(body).result

j = 0
CURR = 0
balances = []
addresses = []
max-address = 0
erc20-addresses = <[ 0xd0d6d6c5fe4a677d343cc433536bb717bae167dd 0x960b236A07cf122663c4303350609A66A7B288C0 0x1f573d6fb3f13d689ff844b4ce37794d79a7ff1c 0x0d8775f648430679a709e98d2b0cb6250d2887ef 0xff3519eeeea3e76f1f699ccce5e23ee0bdda41ac 0x5af2be193a6abca9c8817001f45744777db30756 0x41e5560054824ea6b0732e656e3ad64e20e94e45 0x12fef5e57bf45873cd9b62e9dbd7bfb99e32d73e 0xe0b7927c4af23765cb51314a0e0521a9645f0e2a 0x2e071D2966Aa7D8dECB1005885bA1977D6038A65 0x0abdace70d3790235af448c88547603b945604ea 0x08711d3b02c8758f2fb3ab4e80228418a7f8e39c 0x86fa049857e0209aa7d9e616f7eb3b3b78ecfdb0 0xaf30d2a7e90d7dc361c8c4585e9bb7d2f6f15bc7 0x419d0d8bdd9af5e606ae2232ed285aff190e711b 0x6810e776880c02933d47db1b9fc05908e5386b96 0xa74476443119A942dE498590Fe1f2454d7D4aC0d 0xf7b098298f7c69fc14610bf71d5e02c60792894c 0xcbcc0f036ed4788f63fc0fee32873d6a7487b908 0x888666CA69E0f178DED6D75b5726Cee99A87D698 0xdd974d5c2e2928dea5f71b9825b8b646686bd200 0xfa05A73FfE78ef8f1a739473e462c54bae6567D9 0xBEB9eF514a379B997e0798FDcC901Ee474B6D9A1 0xF433089366899D83a9f26A773D59ec7eCF30355e 0xc66ea802717bfb9833400264dd12c2bceaa34a6d 0xb63b606ac810a52cca15e44bb630fd42d8d1d83d 0xcfb98637bcae43C13323EAa1731cED2B716962fD 0x1776e1f26f98b1a5df9cd347953a26dd3cb46671 0xd26114cd6EE289AccF82350c8d8487fedB8A0C07 0xD8912C10681D8B21Fd3742244f44658dBA12264E 0x9a642d6b3368ddc662CA244bAdf32cDA716005BC 0xe94327d07fc17907b4db788e5adf2ed424addff6 0x607F4C5BB672230e8672085532f7e901544a7375 0x7c5a0ce9267ed19b22f8cae653f198e3e8daf098 0xaec2e87e0a235266d9c5adc9deb4b2e29b54d009 0x744d70fdbe2ba4cf95131626614a1763df805b9e 0xb64ef51c888972c908cfacf59b47c1afbc0ab8ac 0xb9e7f8568e08d5659f5d29c4997173d84cdf2607 0xe7775a6e9bcf904eb39da2b68c5efb4f9360e08c 0xB97048628DB6B661D4C2aA833e95Dbe1A905B280 0x6531f133e6deebe7f2dce5a0441aa7ef330b4e53 0xaaaf91d9b90df800df4f55c205fd6989c977e73a 0xcb94be6f13a1182e4a4b6140cb7bf2025d28e41b 0x5c543e7AE0A1104f78406C340E9C64FD9fCE5170 0x667088b212ce3d06a1b553a7221E1fD19000d9aF 0x4DF812F6064def1e5e029f1ca858777CC98D2D81 0xe41d2489571d322189246dafa5ebde1f4699f498 ]> 

max-item = erc20-addresses.length - 1

# get-balances-cycle=(address, cb)~>
# 	get-tokens-balance erc20-addresses[CURR], address, (err,res)~>
# 		sleep.msleep 100
# 		if err
# 			console.log \err: err 
# 			return get-balances-cycle(address,cb)

# 		balances.push +res

# 		process.stdout.clearLine!
# 		process.stdout.cursorTo(0)
# 		process.stdout.write("=== address: #{j+1}/#{max-address+1} === contract: #{CURR+1} of #{max-item+1} === balances length: #{p.compact(balances).length}")
# 		# process.stdout.clearLine!
# 		# process.stdout.cursorTo(0)

# 		if CURR == max-item 
# 			out = p.compact(balances).length
# 			balances := []	
# 			CURR := 0	
# 			console.log '  |  total:' p.compact(balances).length
# 			if out >= 5 => return cb addresses[j]
# 			else return cb ''
# 		else 
# 			CURR += 1
# 			get-balances-cycle(address,cb)


# fs.readFile \result.txt, \UTF8, (err,res)~>
# 	addresses :=  p.lines res
# 	max-address := addresses.length - 1


# 	(get-balances-for-all=~>
# 		get-balances-cycle addresses[j], (res)~>
# 			str = "#{res}\n"
# 			if res => fs.appendFileSync \filtered.txt str
# 			if j == max-address => return console.log \DONE
# 			j += 1
# 			get-balances-for-all!
# 	)()

get-kind-of-tokens-count=(address,cb)-> request 'https://etherscan.io/address/'+address, (err,res,body)->
	count = +body.replace /[\S\s]+title\=\'([\S]+?) Token Contracts[\S\s]+/gi, '$1'

	process.stdout
		..clearLine!
		..cursorTo(0)
		..write("#{j+1}/#{max-address+1} === #{address} === tokens: #{count||'0or1'}\n")
	if count >= 5 => return cb address
	else return cb null


fs.readFile \result.txt, \UTF8, (err,res)~>
	addresses :=  p.lines res
	max-address := addresses.length - 1

	(get-balances-for-all=~>
		get-kind-of-tokens-count addresses[j], (res)~>
			str = "#{res}\n"
			if res => fs.appendFileSync \filtered.txt str				
			if j == max-address => return console.log \DONE
			j += 1
			get-balances-for-all!
	)()
