const { execSync } = require('child_process');
const fs = require('fs');

const data = JSON.parse(fs.readFileSync('.bds-cache/alerts.json', 'utf8'));
const alerts = data.alerts || [];
let sent = 0;
let failed = 0;

for (let i = 0; i < alerts.length; i++) {
  try {
    const result = execSync('./notify ' + JSON.stringify(alerts[i]), {
      encoding: 'utf8',
      timeout: 30000
    });
    sent++;
    console.log(`[${i+1}/${alerts.length}] sent`);
  } catch (e) {
    failed++;
    console.log(`[${i+1}/${alerts.length}] failed: ${e.message.slice(0,80)}`);
  }
}

console.log(`\nDispatched ${sent}/${alerts.length} alerts (${failed} failed)`);
console.log(`epoch_end: ${data.epoch_end}`);
