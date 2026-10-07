// =========================================================================
// GOOGLE APPS SCRIPT: AUTO SYNC LEADS, CREATE GOOGLE DRIVE FOLDER & NOTIFY
// =========================================================================
// इस कोड को अपनी Google Sheet के Extensions -> Apps Script में पेस्ट करें:

function doPost(e) {
  try {
    var lock = LockService.getScriptLock();
    lock.waitLock(30000);

    var sheet = SpreadsheetApp.getActiveSpreadsheet().getActiveSheet();
    var data = JSON.parse(e.postData.contents);

    // अगर पहली बार है तो Headers बना दें
    if (sheet.getLastRow() === 0) {
      sheet.appendRow([
        "Timestamp",
        "Client Name",
        "WhatsApp Phone",
        "Business Type",
        "Target Revenue",
        "Maintenance Preference",
        "Selected Plan",
        "Estimated Budget (INR)",
        "Domain",
        "Drive/Photo Link",
        "Services Details",
        "Drive Folder Link",
        "Status"
      ]);
      // Header Styling
      sheet.getRange(1, 1, 1, 13).setBackground("#16a34a").setFontColor("#ffffff").setFontWeight("bold");
    }

    // ऑटोमैटिक Google Drive में क्लाइंट के नाम से फोल्डर बनाना
    var parentFolderId = "YOUR_GOOGLE_DRIVE_PARENT_FOLDER_ID"; // अपनी Drive का Folder ID यहाँ डालें (वैकल्पिक)
    var clientFolderName = (data.clientName || "New_Lead") + "_" + (data.clientPhone || "NoPhone");
    var folderUrl = "Not Generated";

    try {
      if (parentFolderId && parentFolderId !== "YOUR_GOOGLE_DRIVE_PARENT_FOLDER_ID") {
        var parentFolder = DriveApp.getFolderById(parentFolderId);
        var newFolder = parentFolder.createFolder(clientFolderName);
        folderUrl = newFolder.getUrl();
      }
    } catch (driveErr) {
      folderUrl = "Drive Error: " + driveErr.toString();
    }

    // डेटा को Sheet में लिखना
    sheet.appendRow([
      new Date(),
      data.clientName || "",
      "'" + (data.clientPhone || ""),
      data.bizType || "",
      data.targetRev || "",
      data.maintChoice || "",
      data.selectedPlan || "",
      data.planPrice || 0,
      (data.onboarding && data.onboarding.domain) || "",
      (data.onboarding && data.onboarding.driveLink) || "",
      (data.onboarding && data.onboarding.services) || "",
      folderUrl,
      "New Lead - Quotation Sent"
    ]);

    lock.releaseLock();

    return ContentService
      .createTextOutput(JSON.stringify({ "result": "success", "folderUrl": folderUrl }))
      .setMimeType(ContentService.MimeType.JSON);

  } catch (error) {
    return ContentService
      .createTextOutput(JSON.stringify({ "result": "error", "error": error.toString() }))
      .setMimeType(ContentService.MimeType.JSON);
  }
}
