const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const root = path.resolve(__dirname, '..');
const read = p => fs.readFileSync(path.join(root, p), 'utf8');
const info = read('common/mod.info');
assert.match(info, /^id=TABASSCTCompatibility$/m);
assert.match(info, /^require=ShadowCatTacticsDispatch,ShadowCatTacticsGuardian,TakeABathAndShowerNew$/m);
assert.match(info, /^versionMin=42\.20\.4$/m);
const lua = read('common/media/lua/shared/TABASSCTCompatibility.lua');
assert.equal([...lua.matchAll(/"Base\.[^"]+"/g)].length, 8);
assert.doesNotMatch(lua, /AddExcludeBodyLocations|canAutoUnequipClothing\s*=|Events\./);
assert.doesNotMatch(info + lua, /4123567854998|TDWRegistries|tdw:/);
const workshop = read('workshop/workshop.txt');
assert.match(workshop, /^id=$/m);
assert.match(workshop, /^visibility=friendsOnly$/m);
for (const id of ['3592172476', '3689462578', '3609052036']) assert.ok(workshop.includes(id));
console.log('PASS metadata, narrow scope, independent dependency and publication-gate contracts');

assert.match(info, /^poster=poster\.png$/m);
for (const [file, size] of [['common/poster.png',512],['workshop/preview.png',256]]) {
 const data=fs.readFileSync(path.join(root,file));
 assert.equal(data.subarray(0,8).toString('hex'),'89504e470d0a1a0a');
 assert.equal(data.readUInt32BE(16),size); assert.equal(data.readUInt32BE(20),size);
 assert.ok(data.length < 1024*1024);
}
console.log('PASS artwork dimensions and size');
