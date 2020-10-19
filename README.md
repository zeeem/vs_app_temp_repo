# vital_signs_ui_template

UI added, VS visualization page, BT connectivity

### For Jeff:
Duplicate any of the `formsfill_page `and change it as needed for new pages.

### For Jack:
for Alert part, please look into the `Processing/BTconnection.dart`.
Function: `_checkAndIssueWarning`

For the static variables look into `core/configVS.dart`. 
I was using the local_config part for storing the alert range. You can use json file to do this as david asked.

I have tried to put comments. Although, codes might not look organized due to the regular experiments. 
PS. I don't think you can test the alert system from this app, as it needs the device connected to go to that page.