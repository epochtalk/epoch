let rolesPermissions = require('./roles_permissions.json')
const fs = require('fs')

function flattenObject(ob) {
    var toReturn = {};

    for (var i in ob) {
        if (!ob.hasOwnProperty(i)) continue;

        if ((typeof ob[i]) == 'object' && ob[i] !== null) {
            var flatObject = flattenObject(ob[i]);
            for (var x in flatObject) {
                if (!flatObject.hasOwnProperty(x)) continue;

                toReturn[i + '.' + x] = flatObject[x];
            }
        } else {
            toReturn[i] = ob[i];
        }
    }
    return toReturn;
}

let allPermissions = {}
let priorityRestrictions = {}
// process permissions for each role
Object.keys(rolesPermissions).forEach(function(role) {
  console.log(role)
  // get permissions out of role permissions for this role
  let permissions = flattenObject(rolesPermissions[role])
  // filter priorityRestrictions for each role
  Object.keys(permissions).forEach(key => {
    if (key.indexOf('priorityRestrictions') == 0) {
      console.log(role + '.priorityRestrictions', rolesPermissions[role].priorityRestrictions)
      priorityRestrictions[role] = rolesPermissions[role].priorityRestrictions
      // // priorityRestrictions[role] = priorityRestrictions[role]
      delete permissions[key]
    }
  })
  allPermissions = {...allPermissions, ...permissions}
})
let allPermissionsString = JSON.stringify(Object.keys(allPermissions).sort(), null, 2)
let priorityRestrictionsString = JSON.stringify(priorityRestrictions, null, 2)
console.log(allPermissionsString)
console.log(priorityRestrictionsString)
fs.writeFileSync('priv/repo/seeds/permissions.json', allPermissionsString)
fs.writeFileSync('priv/repo/seeds/priority_restrictions.json', priorityRestrictionsString)
