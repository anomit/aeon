import json

with open('.bds-cache/latest.json') as f:
    data = json.load(f)

epoch_begin = data.get('epoch', {}).get('begin', 'N/A')
epoch_end = data.get('epoch', {}).get('end', 'N/A')
trade_data = data.get('tradeData', {})

total_trades = 0
whales = []

for pool_addr, pool_info in trade_data.items():
    trades = pool_info.get('trades', [])
    for trade in trades:
        total_trades += 1
        trade_usd = trade.get('data', {}).get('calculated_trade_amount_usd', 0)
        tx_hash = trade.get('log', {}).get('transactionHash', 'N/A')
        block_num = trade.get('log', {}).get('blockNumber', 0)
        if trade_usd >= 1000:
            whales.append({
                'pool': pool_addr,
                'tx': tx_hash,
                'block': block_num,
                'usd': round(trade_usd, 2),
                'token0_amt': trade.get('data', {}).get('calculated_token0_amount', 0),
                'token1_amt': trade.get('data', {}).get('calculated_token1_amount', 0),
            })

print(f'Epoch: {epoch_begin}-{epoch_end}')
print(f'Total trades: {total_trades}')
print(f'Whales (>=1000 USD): {len(whales)}')
print()
for w in whales:
    fp = w['tx'] + ':' + str(w['block'])
    print(json.dumps({
        'usd': w['usd'],
        'pool': w['pool'],
        'tx': w['tx'],
        'block': w['block'],
        'token0': w['token0_amt'],
        'token1': w['token1_amt'],
        'fp': fp
    }))
