# 🚀 NamiraChecker

**NamiraChecker** is a Flutter-based tool that fetches and filters **v2ray** configs from the official [Namira Subscription](https://github.com/NaMiraNet) and [Namira Website](https://namira.dev). It ensures you only keep the fastest, most reliable configs — and skips the dead ones.

---

## 🛑 **IMPORTANT NOTICE**

> **⚠️ This app does *not* make any connections itself.  
> It ONLY collects, filters, and keeps your v2ray configs updated.  
> No connection, tunneling, or proxying happens inside this tool.**

---

## 🌐 What Does It Do?

- Fetches v2ray configs using your [Namira Subscription](https://github.com/NaMiraNet)
- Pings each config using your internet connection
- Automatically removes unreachable configs before they reach your client
- Supports pinging via various social media routes for more accurate results
- Runs a background service that updates your configs every few hours
- Helps you stay connected even if your internet status changes suddenly

---

## ⚙️ Features

- ✅ Built with Flutter
- 🔁 Background service for periodic config updates
- 🧠 Smart pinging system using real-world social platforms
- 🗂️ Auto-filters out broken configs
- 💾 Keeps your client always stocked with fresh working configs
- 🔒 Safe by design: **no connection happens in the app itself**

---

## 🔄 How It Works

```text
1. Get subscription configs from Namira
2. Ping each config using your internet connection
3. Discard any configs that don't respond
4. Save and update the filtered list
5. Your v2ray client uses only the best configs
