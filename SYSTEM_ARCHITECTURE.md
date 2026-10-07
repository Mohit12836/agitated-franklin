# 🏛️ MOHIT JAIN AI WEBSITE SALES & DISCOVERY SYSTEM: MASTER ARCHITECTURE

यह डॉक्यूमेंट आपके पूरे **AI Website Sales & Discovery Engine** का मास्टर ब्लूप्रिंट है। इस सिस्टम की सबसे बड़ी ताकत यह है कि **आपको हर ग्राहक के लिए बार-बार अलग से मेहनत या मैनुअल सेल्स पेज नहीं बनाना पड़ेगा**—यह मास्टर इंजन खुद हर ग्राहक के उत्तरों और साइकोलॉजी के अनुसार रीयल-टाइम में उसका प्लान, प्राइस, स्कोप और प्रपोजल जनरेट कर देगा।

---

## 🧭 1. एंड-टू-एंड सेल्स व डिस्कवरी फ्लो (End-to-End Master Flow)

```text
               Facebook / Instagram / WhatsApp Ad
                               ↓
                        "Hi / Hello"
                               ↓
        ┌──────────────────────────────────────────────┐
        │  AI Opening Script (Opportunity Discovery)   │
        └──────────────────────┬───────────────────────┘
                               ↓
        ┌──────────────────────────────────────────────┐
        │ 20-30 Dynamic Questions (Branched by Sector) │
        └──────────────────────┬───────────────────────┘
                               ↓
        ┌──────────────────────────────────────────────┐
        │     Extracted Lead Intelligence Profile      │
        │   (Pain + Ambition + Gap + Budget Signals)   │
        └──────────────────────┬───────────────────────┘
                               ↓
        ┌──────────────────────────────────────────────┐
        │        Live AI Opportunity & Gap Report      │
        │      ("आप अभी कहाँ हैं → कहाँ जा सकते हैं")  │
        └──────────────────────┬───────────────────────┘
                               ↓
        ┌──────────────────────────────────────────────┐
        │   Possibility Ladder & Tailored Quotation    │
        │ (Starter ₹1,999 / Pro ₹8,999 / Scale ₹24,999)│
        └──────────────────────┬───────────────────────┘
                               ↓
                   [ Before Payment Action ]
         Low Friction Token Lock + WhatsApp Proposal
                               ↓
                   [ After Payment Portal ]
           Deep VIP Onboarding & Asset Collection
         (Logo, Products, Domain, Drive Folder Sync)
                               ↓
       Supabase (Source of Truth) + Google Sheets (CRM)
```

---

## 🧠 2. पेमेंट से पहले बनाम पेमेंट के बाद का सख्त नियम

| चरण | क्या करना है (Allowed) | क्या बिल्कुल नहीं करना (Avoid) |
|---|---|---|
| **Payment से पहले** | • सिर्फ 20-सेकंड की रोचक डिस्कवरी<br>• दर्द और डिजिटल गैप दिखाना<br>• सिर्फ नाम और WhatsApp नंबर | ❌ 10-पेज का लंबा फॉर्म भरवाना<br>❌ लोगो या GST नंबर मांगना<br>❌ झूठा डर या फेक वादे दिखाना |
| **Payment के बाद** | • VIP Onboarding Portal<br>• लीगल नाम, डोमेन, Drive फोटो लिंक<br>• कैटलॉग और मुख्य सर्विसेज | ❌ ग्राहक को छोड़ देना या ढिलाई बरतना |

---

## 📊 3. डेटाबेस और टूल्स का सही आर्किटेक्चर (Data Stack)

1. **Supabase (PostgreSQL - Source of Truth):**
   - पूरी रिलेशनल इंटीग्रिटी: `leads`, `discovery_sessions`, `lead_intelligence_profiles`, `opportunity_reports`, `quotations`, `payments`, `onboarding_projects`, `maintenance_subscriptions`।
   - स्कीमा फाइल: [supabase_schema.sql](file:///c:/Users/hp/Documents/antigravity/agitated-franklin/supabase_schema.sql)।

2. **Google Sheets (Business & CRM View):**
   - आपके लिए 1-स्क्रीन पर सभी लीड्स का लाइव स्टेटस (New Lead -> Proposal Sent -> Token Paid -> Live)।
   - ऑटो-सिंक स्क्रिप्ट: [google_apps_script.js](file:///c:/Users/hp/Documents/antigravity/agitated-franklin/google_apps_script.js)।

3. **Google Drive (Automated Asset Vault):**
   - हर ग्राहक के नाम और फ़ोन नंबर से ऑटोमैटिक अलग फोल्डर बनता है।

---

## 🎯 4. WhatsApp Ad "Hi/Hello" मास्टर ओपनिंग स्क्रिप्ट

जब भी कोई नया व्यक्ति Ad देखकर WhatsApp पर **"Hi"** या **"Hello"** भेजे, तो उसे यह ऑटो-रिप्लाई जाना चाहिए:

> *"नमस्ते [Name/Sir]! 🙏*  
> *मैं पहले आपका Business समझना चाहूँगा। आपको वेबसाइट बनवाने की जरूरत है भी या नहीं—यह बाद में तय करेंगे।*  
> *नीचे दिए गए 20-सेकंड के फ्री AI डायग्नोस्टिक टूल से अपने बिजनेस का तुरंत **डिजिटल गैप और कस्टमाइज्ड ग्रोथ प्लान** देखें:*  
>  
> 🔗 **https://your-domain.vercel.app**  
>  
> *(इसमें आपके सेक्टर के हिसाब से ₹1,999 से लेकर एडवांस प्लान तक का पूरा हिसाब और स्कोप लाइव दिख जाएगा।)*"

---

## 🚀 5. लाइव टेस्ट और डिप्लॉयमेंट

1. आप सीधे ब्राउज़र में [index.html](file:///c:/Users/hp/Documents/antigravity/agitated-franklin/index.html) खोलकर इस पूरे इंटरैक्टिव अनुभव को टेस्ट कर सकते हैं।
2. ऊपर दिए गए **"Agency CRM"** बटन पर क्लिक करके आप लाइव सेशन का JSON पेलोड और पाइपलाइन मेट्रिक्स देख सकते हैं।
3. इसे Vercel या Netlify पर डिप्लॉय करके सीधे अपने Ads कैंपेन से कनेक्ट किया जा सकता है।
