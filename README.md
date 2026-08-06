# 3x-ui Railway (نسخه فیکس شده)

این نسخه مشکلات نسخه قبلی رو برطرف کرده و بر پایه سورس اصلی ساخته شده.

## تغییرات و فیکس‌ها

- ✅ مشکل پورت (`$PORT`) کاملاً حل شد
- ✅ nginx روی پورت صحیح Railway گوش می‌دهد
- ✅ تنظیمات فقط یک بار اعمال می‌شود (نه هر بار)
- ✅ **هر Path دلخواهی** در پنل قابل استفاده است (دیگر محدود به `/in1` تا `/in9` نیست)
- ✅ ساختار تمیز و نزدیک به سورس اصلی
- ✅ پشتیبانی از IP Limit (بخش IP Limit در پنل باز و قابل ویرایش است)

## نحوه دیپلوی

1. این ۴ فایل را در یک ریپازیتوری گیت‌هاب آپلود کنید:
   - `Dockerfile`
   - `start.sh`
   - `nginx.conf.template`
   - `README.md`

2. در Railway پروژه جدید بسازید → Deploy from GitHub

3. **حتماً** یک Volume به مسیر `/etc/x-ui` اضافه کنید

4. در بخش Networking:
   - Target Port را روی **`8080`** بگذارید (یا خالی بگذارید تا Railway خودش تشخیص دهد)

---

## تنظیمات Inbound (مهم)

در پنل یک Inbound جدید بسازید:

| فیلد            | مقدار                     |
|-----------------|---------------------------|
| Protocol        | VLESS / VMess / Trojan    |
| Listen Port     | **8080**                  |
| Listen IP       | `0.0.0.0`                 |
| Network         | `ws`                      |
| Path            | هر چیزی که دوست دارید (مثلاً `/cdn`, `/api`, `/vpn`) |

> حالا می‌توانید **هر Path دلخواهی** استفاده کنید.

---

## لینک کلاینت نمونه

```
vless://UUID@your-domain.up.railway.app:443?encryption=none&security=tls&sni=your-domain.up.railway.app&fp=chrome&alpn=http/1.1&type=ws&host=your-domain.up.railway.app&path=/cdn#Config
```

---

## نکات مهم

- Volume حتماً اضافه کنید
- پورت Inbound حتماً **8080** باشد
- IP Limit در پنل حالا باز و قابل ویرایش است
- از همه پروتکل‌ها پشتیبانی می‌شود

---

ساخته شده بر پایه سورس اصلی MHSanaei/3x-ui با فیکس‌های مخصوص Railway.