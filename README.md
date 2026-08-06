# 3x-ui روی Railway (بهینه‌سازی شده از سورس اصلی)

این نسخه از **سورس اصلی MHSanaei/3x-ui** استفاده می‌کنه و فقط تغییرات لازم برای Railway رو روش اعمال کرده.

## ویژگی‌های مهم این نسخه

- استفاده مستقیم از سورس اصلی (v3.6.0)
- پشتیبانی از **همه پروتکل‌ها** (VLESS, VMess, Trojan, Shadowsocks و ...)
- استفاده صحیح از متغیر `$PORT` Railway (نه هاردکد 3000)
- تنظیمات اولیه فقط **یک بار** اعمال می‌شه
- پشتیبانی از Volume برای حفظ دیتابیس
- ساختار تمیز و نزدیک به سورس اصلی

## نحوه دیپلوی (خیلی ساده)

### ۱. ساخت ریپازیتوری
یک ریپازیتوری جدید در گیت‌هاب بساز و این ۴ فایل رو داخلش کپی کن:
- `Dockerfile`
- `start.sh`
- `nginx.conf.template`
- `README.md`

### ۲. Deploy روی Railway
1. **New Project → Deploy from GitHub repo**
2. ریپازیتوری خودت رو انتخاب کن
3. بعد از Deploy موفق، برو به **Settings → Networking** و **Generate Domain** بزن

### ۳. اضافه کردن Volume (خیلی مهم!)
برای اینکه تنظیمات و کاربرانت پاک نشه:

1. برو به **Settings → Volumes**
2. **Add Volume** بزن
3. مسیر رو بذار: `/etc/x-ui`
4. Volume رو ذخیره کن

### ۴. اولین ورود به پنل
آدرس پنل:
```
https://your-app.up.railway.app/managepanel/
```

یوزرنیم و پسورد پیش‌فرض: `admin` / `admin`  
**حتماً بلافاصله پسورد رو تغییر بده.**

---

## تنظیمات Inbound (مهم)

در پنل یک Inbound جدید بساز با این تنظیمات:

| فیلد              | مقدار پیشنهادی          |
|-------------------|--------------------------|
| Protocol          | VLESS / VMess / Trojan   |
| Listen Port       | **8080**                 |
| Listen IP         | `0.0.0.0`                |
| Network           | ws                       |
| Security          | none                     |
| Path              | `/` یا `/vless` یا `/vmess` |

> نکته: چون nginx همه چیز رو به پورت ۸۰۸۰ می‌فرسته، همه اینباندهایت باید روی **۸۰۸۰** ساخته بشن.

---

## لینک کلاینت نمونه

```
vless://UUID@your-app.up.railway.app:443?encryption=none&security=tls&sni=your-app.up.railway.app&fp=chrome&type=ws&host=your-app.up.railway.app&path=/vless#MyConfig
```

---

## متغیرهای محیطی (اختیاری)

اگر خواستی می‌تونی در Railway این متغیرها رو ست کنی:

| متغیر            | مقدار پیش‌فرض     | توضیح |
|------------------|-------------------|-------|
| `PANEL_PATH`     | `/managepanel/`   | مسیر پنل |
| `SUB_PATH`       | `/sub/`           | مسیر ساب‌لینک |
| `XUI_PORT`       | `2053`            | پورت داخلی پنل |
| `SUB_PORT`       | `2096`            | پورت ساب‌لینک |
| `INBOUND_PORT`   | `8080`            | پورت اینباند |

---

## نکات مهم Railway

- **Volume** حتماً اضافه کن (وگرنه با هر ری‌دیپلوی همه چیز پاک می‌شه)
- پورت Inbound حتماً **۸۰۸۰** باشه
- می‌تونی چندین اینباند با Path متفاوت داشته باشی
- از همه پروتکل‌ها پشتیبانی می‌شه

---

## تست سریع

- پنل: `https://your-app.up.railway.app/managepanel/`
- تست اینباند: `https://your-app.up.railway.app/vless` (باید Bad Request بده)

---

ساخته شده بر پایه سورس اصلی MHSanaei/3x-ui با بهینه‌سازی مخصوص Railway.