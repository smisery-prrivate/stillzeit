// Keeps the script fingerprint in index.html's Content-Security-Policy in step with the script itself.
// The browser only runs the inline <script> block when its sha256 matches the value in the policy;
// a stale value means a blank app. Run this after every change to that block.
//
//   node tools/csp-hash.js            write the current fingerprint into index.html
//   node tools/csp-hash.js --check    only compare; exit 1 when stale (used by tools/hooks/pre-commit)
//   node tools/csp-hash.js --check -  compare the text on stdin instead of the file
const fs = require('fs'), path = require('path'), crypto = require('crypto');
const FILE = path.join(__dirname, '..', 'index.html');
const args = process.argv.slice(2), checkOnly = args.includes('--check'), fromStdin = args.includes('-');

const raw = fromStdin ? fs.readFileSync(0, 'utf8') : fs.readFileSync(FILE, 'utf8');
// the browser reads CRLF as LF before it looks at the script, so the fingerprint is taken the same way
const blocks = raw.replace(/\r\n?/g, '\n').match(/<script>[\s\S]*?<\/script>/g) || [];
if (blocks.length !== 1) { console.error('csp-hash: expected exactly one inline <script> block, found ' + blocks.length); process.exit(2); }
const want = "'sha256-" + crypto.createHash('sha256').update(blocks[0].slice('<script>'.length, -'</script>'.length), 'utf8').digest('base64') + "'";
const meta = raw.match(/<meta http-equiv="Content-Security-Policy" content="[^"]*">/);
const have = meta && (meta[0].match(/'sha256-[A-Za-z0-9+\/=]+'/g) || []);
if (!meta || have.length !== 1) { console.error('csp-hash: expected one Content-Security-Policy meta tag with one sha256 value'); process.exit(2); }

if (have[0] === want) { console.log('csp-hash: fingerprint is current'); process.exit(0); }
if (checkOnly) {
  console.error('csp-hash: the script in index.html changed but the fingerprint in its Content-Security-Policy did not.\n' +
    '          The app would stay blank. Run:  node tools/csp-hash.js   then add index.html again.');
  process.exit(1);
}
fs.writeFileSync(FILE, raw.replace(meta[0], meta[0].replace(have[0], want)));
console.log('csp-hash: fingerprint updated to ' + want);
