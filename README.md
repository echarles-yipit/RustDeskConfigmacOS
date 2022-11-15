# RustDeskConfigmacOS

Tools for deploying Rust Desk Client with macOS.

The script deploys configurations to plists to include the public key, relay URL and pass the randomly generated password up to Jamf. 

The extension attribute pushes the user's ID up to the JSS as well, but the app needs to run at least once for the field to be populated in the plist and by extension this extension attribute.
