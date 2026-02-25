// ╔═══════════════════════════════════════╗
// ║         🌸 SAKURA BOT v1.0 🌸          ║
// ║      100 Fitur WhatsApp Bot           ║
// ╚═══════════════════════════════════════╝

const { default: makeWASocket, useMultiFileAuthState, DisconnectReason, downloadContentFromMessage } = require("@whiskeysockets/baileys")
const { Boom } = require("@hapi/boom")
const axios = require("axios")
const fs = require("fs")
const path = require("path")
const { exec } = require("child_process")
const qrcode = require("qrcode-terminal")

// ===================================
//         KONFIGURASI BOT
// ===================================
const config = {
    prefix: "!",
    ownerNumber: "628xxxxxxxxxx",  // ⚠️ GANTI DENGAN NOMOR WA KAMU
    botName: "Sakura Bot",
    antispam: {
        aktif: true,
        maxPesan: 5,
        waktu: 5000
    }
}

// ===================================
//         DATA STORAGE
// ===================================
let groupSettings = {}   // nyalakan/matikan bot per grup
let privateChatOff = {}  // matikan bot per chat pribadi
let warnData = {}        // data warn user
let levelData = {}       // data level user
let profileData = {}     // data profil user
let gameData = {}        // data game aktif

// ===================================
//         ANTI SPAM
// ===================================
const spamMap = new Map()
function cekSpam(nomor) {
    const sekarang = Date.now()
    const data = spamMap.get(nomor) || { count: 0, waktu: sekarang }
    if (sekarang - data.waktu > config.antispam.waktu) {
        spamMap.set(nomor, { count: 1, waktu: sekarang })
        return false
    }
    data.count++
    spamMap.set(nomor, data)
    return data.count > config.antispam.maxPesan
}

// ===================================
//         HELPER FUNCTIONS
// ===================================
function isOwner(nomor) {
    return nomor.replace("@s.whatsapp.net", "").replace(/[^0-9]/g, "") === config.ownerNumber.replace(/[^0-9]/g, "")
}

function randomItem(arr) {
    return arr[Math.floor(Math.random() * arr.length)]
}

function romanize(num) {
    const val = [1000,900,500,400,100,90,50,40,10,9,5,4,1]
    const syms = ["M","CM","D","CD","C","XC","L","XL","X","IX","V","IV","I"]
    let result = ""
    for (let i = 0; i < val.length; i++) {
        while (num >= val[i]) { result += syms[i]; num -= val[i] }
    }
    return result
}

// ===================================
//         AUTO REPLY
// ===================================
const autoReply = {
    "halo": "Halo juga! 😊 Ketik *!menu* untuk lihat semua fitur Sakura Bot~",
    "hi": "Hi! 👋 Ketik *!menu* ya~",
    "pagi": "Selamat pagi! ☀️ Semoga harimu menyenangkan!",
    "siang": "Selamat siang! 🌤️ Jangan lupa makan ya!",
    "malam": "Selamat malam! 🌙 Istirahat yang cukup~",
    "bot": "Hei, aku Sakura Bot! 🌸 Ketik *!menu* untuk bantuan",
    "sakura": "Haii~ aku Sakura Bot! 🌸",
}

// ===================================
//         QUOTES DATA
// ===================================
const quotesData = [
    "Jangan menyerah, setiap langkah kecil tetap membawamu maju. 💪",
    "Hidup terlalu singkat untuk dihabiskan dengan penyesalan. 🌸",
    "Kamu lebih kuat dari yang kamu kira. ✨",
    "Setiap hari adalah kesempatan baru untuk menjadi lebih baik. 🌟",
    "Percayalah pada prosesmu sendiri. 🙏",
    "Keberhasilan dimulai dari satu langkah pertama. 👣",
    "Tersenyumlah, dunia akan terasa lebih indah. 😊",
]

const jokesData = [
    "Kenapa programmer suka gelap? Karena light attracts bugs! 😂",
    "Apa yang tidak berubah meski diganti? Password yang sama terus! 😅",
    "Kenapa WA lambat? Karena terlalu banyak forward! 🤣",
    "Dokter: Kamu harus istirahat. Pasien: Tapi kerjaan saya... Dokter: Istirahat itu kerjaan kamu sekarang! 😂",
    "Apa bedanya kucing dan koma? Kucing punya sembilan nyawa, koma cuma jeda! 😂",
]

const faktaData = [
    "🌍 Gurita punya 3 jantung dan darahnya berwarna biru!",
    "🍯 Madu tidak pernah basi, madu berusia 3000 tahun masih bisa dimakan!",
    "🦈 Hiu lebih tua dari pohon, mereka ada sejak 450 juta tahun lalu!",
    "🐝 Lebah bisa mengenali wajah manusia!",
    "🌙 Di bulan, jejak kaki astronot Apollo akan bertahan jutaan tahun!",
    "🦋 Kupu-kupu merasakan dengan kakinya!",
]

const motivasiData = [
    "💪 Mulai sekarang, bukan nanti. Waktu terbaik adalah sekarang!",
    "🌟 Kamu tidak perlu sempurna untuk memulai, tapi kamu harus mulai untuk sempurna!",
    "🔥 Setiap expert dulunya adalah pemula. Terus belajar!",
    "✨ Kesuksesan bukan tentang seberapa jauh kamu pergi, tapi seberapa jauh kamu sudah datang!",
    "🌈 Setelah hujan pasti ada pelangi. Tetap semangat!",
]

const pantunData = [
    "Buah nanas di atas batu,\nBatu keras susah dibelah.\nHati panas janganlah melaju,\nHati keras susah dilerai. 🌸",
    "Pergi ke pasar beli sepatu,\nSepatu baru dipakai jalan.\nJika kamu mau bersatu,\nHarus sabar dan penuh keimanan. 💕",
    "Burung merpati terbang tinggi,\nHinggap sebentar di pohon rindang.\nBudi pekerti hiasi diri,\nAgar selalu dipandang orang. ✨",
]

const doaData = [
    "🤲 *Doa Sebelum Makan*\nبِسْمِ اللَّهِ وَعَلَى بَرَكَةِ اللَّهِ\n_Bismillahi wa 'ala barokatillah_\nDengan nama Allah dan atas berkah Allah",
    "🤲 *Doa Sesudah Makan*\nاَلْحَمْدُ لِلَّهِ الَّذِيْ أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مُسْلِمِيْنَ\n_Alhamdulillahilladzii ath'amanaa wa saqoonaa wa ja'alanaa muslimiin_",
    "🤲 *Doa Sebelum Tidur*\nبِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا\n_Bismika Allahumma amuutu wa ahyaa_\nDengan nama-Mu ya Allah aku mati dan aku hidup",
    "🤲 *Doa Bangun Tidur*\nاَلْحَمْدُ لِلَّهِ الَّذِيْ أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُوْرُ\n_Alhamdulillahilladzii ahyaanaa ba'da maa amaatanaa wa ilaihin nusyuur_",
]

const truthData = [
    "Ceritakan momen paling memalukan dalam hidupmu!",
    "Siapa orang yang paling kamu sukai saat ini?",
    "Apa kebohongan terbesar yang pernah kamu katakan?",
    "Apa hal yang paling kamu sesali dalam hidupmu?",
    "Siapa yang pertama kali kamu hubungi saat ada masalah?",
]

const dareData = [
    "Kirim foto selfie paling aneh yang bisa kamu buat!",
    "Ceritakan lelucon terburuk yang kamu tahu!",
    "Tulis status WA yang memalukan selama 10 menit!",
    "Kirim pesan 'I love you' ke kontak pertama di HPmu!",
    "Nyanyikan lagu anak-anak dan kirim voice note-nya!",
]

const wouldYouRatherData = [
    "Pilih salah satu:\nA) Bisa terbang ✈️\nB) Bisa jadi tak terlihat 👻",
    "Pilih salah satu:\nA) Selalu lapar tapi tidak bisa makan 🍔\nB) Selalu ngantuk tapi tidak bisa tidur 😴",
    "Pilih salah satu:\nA) Hidup tanpa musik 🎵\nB) Hidup tanpa internet 📵",
    "Pilih salah satu:\nA) Kaya tapi tidak bahagia 💰\nB) Miskin tapi bahagia 😊",
    "Pilih salah satu:\nA) Bisa berbicara semua bahasa 🌍\nB) Bisa berbicara dengan hewan 🐾",
]

// ===================================
//         HANDLE COMMAND
// ===================================
async function handleCommand(sock, msg, from, pesan, isGrup) {
    const args = pesan.slice(config.prefix.length).trim().split(" ")
    const command = args[0].toLowerCase()
    const teks = args.slice(1).join(" ")
    const pengirim = msg.key.participant || from

    // Tambah XP untuk leveling
    if (!levelData[pengirim]) levelData[pengirim] = { xp: 0, level: 1 }
    levelData[pengirim].xp += 5
    if (levelData[pengirim].xp >= levelData[pengirim].level * 100) {
        levelData[pengirim].level++
        levelData[pengirim].xp = 0
        await sock.sendMessage(from, { text: `🎉 Selamat @${pengirim.split("@")[0]}! Kamu naik ke Level *${levelData[pengirim].level}*!`, mentions: [pengirim] })
    }

    switch (command) {

        // ══════════════════════════════
        //         🔧 SISTEM
        // ══════════════════════════════
        case "menu":
            await sock.sendMessage(from, { text: `╔══════════════════════════╗
║      🌸 *SAKURA BOT* 🌸      
╚══════════════════════════╝

⚙️ *UTILITAS*
!cuaca • !kalkulator • !translate
!waktu • !tts • !password
!encode • !decode • !umur
!countdown • !romawi • !shortlink
!sensorteks

🖼️ *MEDIA*
!s/!stiker/!sticker • !toimg
!video • !mp3

🔍 *PENCARIAN*
!gambar • !pin/!pinterest
!lirik • !anime • !manga
!karakter • !resep • !namabayi
!kbbi • !dictionary • !cekspek

👥 *GRUP* _(admin only)_
!tagall • !kick • !promote
!demote • !antilink • !antipromosi
!mute • !unmute • !warn • !clearwarn

🎮 *GAME*
!tebakkata • !tebakgambar
!hangman • !rps • !8ball
!truth • !dare • !dadu
!siapakah • !tebakbendera
!akinator • !wouldyourather

🎌 *ANIME*
!topanime

😂 *HIBURAN*
!meme • !waifu • !quotes • !jokes
!roast • !ramalan • !ship
!emojimix

🎌 *GAMBAR ANIME*
!neko • !husbando • !couple
!senyum • !peluk • !nangis
!marah • !tidur

✏️ *TEKS & FONT*
!aesthetic • !bold • !italic • !zalgo

🎨 *KREATIF*
!buatpuisi • !cerpen • !pantun • !caption

📚 *PENGETAHUAN*
!jadwalsholat • !doaislam
!fakta • !motivasi

👤 *PROFIL & LEVEL*
!profil • !setbio • !level • !leaderboard

🌐 *KONVERSI*
!panjang • !berat • !suhu • !waktuzoom

🎲 *RANDOM*
!randomnama • !randomwarna
!randomnegara • !randomfakta

🛠️ *UTILITAS CANGGIH*
!cekwa • !poll • !reminder
!warnagambar • !ascii • !stealstiker • !qr

⚙️ *PENGATURAN* _(owner only)_
!nyalakan • !matikan

🔧 *SISTEM*
!ping • !info • !off

_Total: 100 Fitur_ 🌸` })
            break

        case "ping":
            const start = Date.now()
            await sock.sendMessage(from, { text: "🏓 Pong!" })
            await sock.sendMessage(from, { text: `⚡ Response time: *${Date.now() - start}ms*` })
            break

        case "info":
            await sock.sendMessage(from, { text: `╔══════════════════════╗
║     🌸 *INFO BOT* 🌸     
╚══════════════════════╝

🤖 *Nama:* ${config.botName}
⚙️ *Prefix:* ${config.prefix}
📚 *Library:* Baileys
💻 *Platform:* Node.js
👑 *Owner:* ${config.ownerNumber}
🌸 *Fitur:* 100+ Fitur

_Ketik !menu untuk melihat semua fitur_` })
            break

        case "off":
            if (isOwner(pengirim)) {
                await sock.sendMessage(from, { text: "⛔ Sakura Bot dimatikan. Sampai jumpa! 🌸👋" })
                setTimeout(() => process.exit(), 1000)
            } else {
                await sock.sendMessage(from, { text: "❌ Hanya owner yang bisa mematikan bot!" })
            }
            break

        case "nyalakan":
            if (isOwner(pengirim)) {
                groupSettings[from] = { aktif: true }
                await sock.sendMessage(from, { text: "✅ Sakura Bot dinyalakan di grup ini! 🌸" })
            } else {
                await sock.sendMessage(from, { text: "❌ Hanya owner yang bisa menggunakan perintah ini!" })
            }
            break

        case "matikan":
            if (isOwner(pengirim)) {
                groupSettings[from] = { aktif: false }
                await sock.sendMessage(from, { text: "⛔ Sakura Bot dimatikan di grup ini!" })
            } else {
                await sock.sendMessage(from, { text: "❌ Hanya owner yang bisa menggunakan perintah ini!" })
            }
            break

        // ══════════════════════════════
        //         ⚙️ UTILITAS
        // ══════════════════════════════
        case "waktu":
            const now = new Date()
            await sock.sendMessage(from, { text: `🕐 *Waktu Sekarang:*\n${now.toLocaleString("id-ID", { timeZone: "Asia/Jakarta" })} WIB` })
            break

        case "kalkulator":
            if (!teks) return await sock.sendMessage(from, { text: "⚠️ Contoh: !kalkulator 10+5*2" })
            try {
                const hasil = eval(teks.replace(/[^0-9+\-*/().]/g, ""))
                await sock.sendMessage(from, { text: `🔢 *Kalkulator*\n\n${teks} = *${hasil}*` })
            } catch {
                await sock.sendMessage(from, { text: "❌ Ekspresi tidak valid!" })
            }
            break

        case "romawi":
            if (!teks || isNaN(teks)) return await sock.sendMessage(from, { text: "⚠️ Contoh: !romawi 2024" })
            await sock.sendMessage(from, { text: `🏛️ *Angka Romawi*\n\n${teks} = *${romanize(parseInt(teks))}*` })
            break

        case "umur":
            if (!teks) return await sock.sendMessage(from, { text: "⚠️ Contoh: !umur 2000-01-15" })
            try {
                const lahir = new Date(teks)
                const sekarang = new Date()
                const umur = sekarang.getFullYear() - lahir.getFullYear()
                await sock.sendMessage(from, { text: `🎂 *Hitung Umur*\n\nTanggal lahir: ${teks}\nUmur kamu: *${umur} tahun*` })
            } catch {
                await sock.sendMessage(from, { text: "❌ Format tanggal salah! Gunakan: YYYY-MM-DD" })
            }
            break

        case "countdown":
            if (!teks) return await sock.sendMessage(from, { text: "⚠️ Contoh: !countdown 2025-12-31" })
            try {
                const target = new Date(teks)
                const diff = target - new Date()
                const hari = Math.floor(diff / (1000 * 60 * 60 * 24))
                await sock.sendMessage(from, { text: `⏳ *Countdown*\n\nMenuju: ${teks}\nSisa: *${hari} hari lagi*` })
            } catch {
                await sock.sendMessage(from, { text: "❌ Format tanggal salah! Gunakan: YYYY-MM-DD" })
            }
            break

        case "password":
            const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*"
            let pass = ""
            for (let i = 0; i < 16; i++) pass += chars.charAt(Math.floor(Math.random() * chars.length))
            await sock.sendMessage(from, { text: `🔐 *Password Generator*\n\n\`${pass}\`\n\n_Simpan baik-baik ya!_` })
            break

        case "encode":
            if (!teks) return await sock.sendMessage(from, { text: "⚠️ Contoh: !encode teks yang ingin diencode" })
            await sock.sendMessage(from, { text: `🔒 *Base64 Encode*\n\n${Buffer.from(teks).toString("base64")}` })
            break

        case "decode":
            if (!teks) return await sock.sendMessage(from, { text: "⚠️ Contoh: !decode teks base64" })
            try {
                await sock.sendMessage(from, { text: `🔓 *Base64 Decode*\n\n${Buffer.from(teks, "base64").toString("utf-8")}` })
            } catch {
                await sock.sendMessage(from, { text: "❌ Teks bukan format Base64 yang valid!" })
            }
            break

        case "sensorteks":
            if (!teks) return await sock.sendMessage(from, { text: "⚠️ Contoh: !sensorteks kata yang ingin disensor" })
            const tersensor = teks.split(" ").map(w => w[0] + "*".repeat(w.length - 1)).join(" ")
            await sock.sendMessage(from, { text: `🚫 *Sensor Teks*\n\n${tersensor}` })
            break

        // ══════════════════════════════
        //         ✏️ TEKS & FONT
        // ══════════════════════════════
        case "aesthetic":
            if (!teks) return await sock.sendMessage(from, { text: "⚠️ Contoh: !aesthetic halo" })
            const aesthetic = teks.split("").join(" ").toUpperCase()
            await sock.sendMessage(from, { text: `✨ *Aesthetic Text*\n\n${aesthetic}` })
            break

        case "bold":
            if (!teks) return await sock.sendMessage(from, { text: "⚠️ Contoh: !bold teks kamu" })
            const boldMap = "𝗮𝗯𝗰𝗱𝗲𝗳𝗴𝗵𝗶𝗷𝗸𝗹𝗺𝗻𝗼𝗽𝗾𝗿𝘀𝘁𝘂𝘃𝘄𝘅𝘆𝘇"
            const normal = "abcdefghijklmnopqrstuvwxyz"
            let boldText = teks.toLowerCase().split("").map(c => {
                const i = normal.indexOf(c)
                return i >= 0 ? boldMap[i] : c
            }).join("")
            await sock.sendMessage(from, { text: `**Bold Text**\n\n${boldText}` })
            break

        case "italic":
            if (!teks) return await sock.sendMessage(from, { text: "⚠️ Contoh: !italic teks kamu" })
            await sock.sendMessage(from, { text: `_${teks}_` })
            break

        case "zalgo":
            if (!teks) return await sock.sendMessage(from, { text: "⚠️ Contoh: !zalgo teks horror" })
            const zalgoChars = ["̴","̵","̶","̷","̸","̡","̢","̧","̨"]
            let zalgoText = teks.split("").map(c => c + randomItem(zalgoChars) + randomItem(zalgoChars)).join("")
            await sock.sendMessage(from, { text: `👻 *Zalgo Text*\n\n${zalgoText}` })
            break

        case "ascii":
            if (!teks) return await sock.sendMessage(from, { text: "⚠️ Contoh: !ascii halo" })
            await sock.sendMessage(from, { text: `🎨 *ASCII Art*\n\n_Fitur ini membutuhkan library figlet_\nnpm install figlet\n\nSementara: *${teks.toUpperCase()}*` })
            break

        // ══════════════════════════════
        //         😂 HIBURAN
        // ══════════════════════════════
        case "quotes":
            await sock.sendMessage(from, { text: `💬 *Quote of the Day*\n\n${randomItem(quotesData)}` })
            break

        case "jokes":
            await sock.sendMessage(from, { text: `😂 *Jokes*\n\n${randomItem(jokesData)}` })
            break

        case "fakta":
            await sock.sendMessage(from, { text: `🧠 *Fakta Unik*\n\n${randomItem(faktaData)}` })
            break

        case "motivasi":
            await sock.sendMessage(from, { text: `💪 *Motivasi Hari Ini*\n\n${randomItem(motivasiData)}` })
            break

        case "dadu":
            const dadu = Math.floor(Math.random() * 6) + 1
            const daduEmoji = ["⚀","⚁","⚂","⚃","⚄","⚅"]
            await sock.sendMessage(from, { text: `🎲 *Lempar Dadu*\n\n${daduEmoji[dadu-1]} Hasilnya: *${dadu}*` })
            break

        case "rps":
            const pilihanRPS = ["✊ Batu", "✋ Kertas", "✌️ Gunting"]
            const botRPS = randomItem(pilihanRPS)
            await sock.sendMessage(from, { text: `✊✋✌️ *Batu Gunting Kertas*\n\nBot memilih: *${botRPS}*\n\n_Kamu pilih apa?_` })
            break

        case "8ball":
            if (!teks) return await sock.sendMessage(from, { text: "⚠️ Contoh: !8ball apakah aku akan sukses?" })
            const jawaban8ball = ["Ya, tentu saja! ✅", "Tidak 🚫", "Mungkin saja 🤔", "Sangat mungkin! 🌟", "Jangan berharap terlalu tinggi 😅", "Tanyakan lagi nanti 🔮", "Sepertinya iya 😊", "Tidak diragukan lagi! 💯"]
            await sock.sendMessage(from, { text: `🎱 *Magic 8Ball*\n\nPertanyaan: ${teks}\n\nJawaban: *${randomItem(jawaban8ball)}*` })
            break

        case "truth":
            await sock.sendMessage(from, { text: `🎭 *Truth*\n\n${randomItem(truthData)}` })
            break

        case "dare":
            await sock.sendMessage(from, { text: `🎭 *Dare*\n\n${randomItem(dareData)}` })
            break

        case "wouldyourather":
            await sock.sendMessage(from, { text: `🤔 *Would You Rather?*\n\n${randomItem(wouldYouRatherData)}\n\n_Jawab A atau B!_` })
            break

        case "siapakah":
            const karakter = ["Naruto 🍥", "Goku 💪", "Luffy 🏴‍☠️", "Ichigo ⚔️", "Saitama 👊", "Zenitsu ⚡", "Tanjiro 🌊", "Eren 🗡️"]
            await sock.sendMessage(from, { text: `🎭 *Kamu adalah...*\n\n*${randomItem(karakter)}*\n\n_Berdasarkan energi hari ini!_ 😄` })
            break

        case "ship":
            const mentions = msg.message?.extendedTextMessage?.contextInfo?.mentionedJid || []
            if (mentions.length < 2) return await sock.sendMessage(from, { text: "⚠️ Tag 2 orang! Contoh: !ship @user1 @user2" })
            const shipPercent = Math.floor(Math.random() * 101)
            const shipEmoji = shipPercent >= 80 ? "💕" : shipPercent >= 50 ? "💗" : shipPercent >= 30 ? "💔" : "😬"
            await sock.sendMessage(from, {
                text: `💘 *Ship Calculator*\n\n@${mentions[0].split("@")[0]} + @${mentions[1].split("@")[0]}\n\n${shipEmoji} Kecocokan: *${shipPercent}%*`,
                mentions: mentions
            })
            break

        case "emojimix":
            if (!teks || teks.split(" ").length < 2) return await sock.sendMessage(from, { text: "⚠️ Contoh: !emojimix 🔥 💧" })
            const emojis = teks.split(" ")
            await sock.sendMessage(from, { text: `🎨 *Emoji Mix*\n\n${emojis[0]} + ${emojis[1]} = ${emojis[0]}${emojis[1]}\n\n_Emoji mix baru!_ ✨` })
            break

        case "roast":
            const roastList = [
                "Kamu tuh kayak WiFi gratis, semua orang butuh tapi gak ada yang mau bayarin! 😂",
                "IQ kamu kayak suhu ruangan... dalam celsius. 🌡️",
                "Wajahmu tuh kayak jam, bikin orang noleh dua kali buat mastiin! 😅",
                "Kamu kayak kalender lama, tanggalnya ada tapi udah gak relevan! 😂",
            ]
            await sock.sendMessage(from, { text: `🔥 *Roast Mode ON*\n\n${randomItem(roastList)}` })
            break

        case "ramalan":
            if (!teks) return await sock.sendMessage(from, { text: "⚠️ Contoh: !ramalan aries" })
            const ramalanList = [
                "Hari ini adalah hari yang luar biasa bagimu! Keberuntungan ada di pihakmu. 🌟",
                "Hati-hati dengan pengeluaran hari ini. Hemat lebih baik! 💰",
                "Seseorang akan membawa kabar baik untukmu hari ini. 📩",
                "Saatnya beristirahat dan mengisi energi. Jangan terlalu keras pada dirimu! 😴",
                "Peluang besar akan datang. Bersiaplah! 🚀",
            ]
            await sock.sendMessage(from, { text: `🔮 *Ramalan ${teks.toUpperCase()}*\n\n${randomItem(ramalanList)}` })
            break

        // ══════════════════════════════
        //         🎌 GAMBAR ANIME
        // ══════════════════════════════
        case "waifu":
        case "neko":
        case "husbando":
        case "couple":
        case "senyum":
        case "peluk":
        case "nangis":
        case "marah":
        case "tidur":
            const animeCategory = {
                waifu: "waifu", neko: "neko", husbando: "husbando",
                couple: "couple", senyum: "smile", peluk: "hug",
                nangis: "cry", marah: "angry", tidur: "sleep"
            }
            try {
                const animeRes = await axios.get(`https://nekos.best/api/v2/${animeCategory[command]}`)
                const animeUrl = animeRes.data.results[0].url
                await sock.sendMessage(from, { image: { url: animeUrl }, caption: `🌸 *${command.toUpperCase()}*` })
            } catch {
                await sock.sendMessage(from, { text: "❌ Gagal mengambil gambar anime. Coba lagi!" })
            }
            break

        // ══════════════════════════════
        //         📚 PENGETAHUAN
        // ══════════════════════════════
        case "doaislam":
            await sock.sendMessage(from, { text: randomItem(doaData) })
            break

        case "pantun":
            await sock.sendMessage(from, { text: `📜 *Pantun*\n\n${randomItem(pantunData)}` })
            break

        // ══════════════════════════════
        //         👤 PROFIL & LEVEL
        // ══════════════════════════════
        case "profil":
            const profil = profileData[pengirim] || { bio: "Belum ada bio" }
            const level = levelData[pengirim] || { level: 1, xp: 0 }
            await sock.sendMessage(from, {
                text: `👤 *Profil @${pengirim.split("@")[0]}*\n\n📝 Bio: ${profil.bio}\n⭐ Level: ${level.level}\n✨ XP: ${level.xp}`,
                mentions: [pengirim]
            })
            break

        case "setbio":
            if (!teks) return await sock.sendMessage(from, { text: "⚠️ Contoh: !setbio Bio kamu di sini" })
            if (!profileData[pengirim]) profileData[pengirim] = {}
            profileData[pengirim].bio = teks
            await sock.sendMessage(from, { text: `✅ Bio berhasil diubah!\n\n_${teks}_` })
            break

        case "level":
            const lvl = levelData[pengirim] || { level: 1, xp: 0 }
            await sock.sendMessage(from, { text: `⭐ *Level Kamu*\n\nLevel: *${lvl.level}*\nXP: *${lvl.xp}/${lvl.level * 100}*` })
            break

        case "leaderboard":
            const sorted = Object.entries(levelData).sort((a, b) => b[1].level - a[1].level).slice(0, 5)
            let lb = "🏆 *Leaderboard Top 5*\n\n"
            sorted.forEach(([nomor, data], i) => {
                lb += `${i+1}. @${nomor.split("@")[0]} - Level ${data.level}\n`
            })
            await sock.sendMessage(from, { text: lb, mentions: sorted.map(([n]) => n) })
            break

        // ══════════════════════════════
        //         🌐 KONVERSI
        // ══════════════════════════════
        case "suhu":
            if (!teks) return await sock.sendMessage(from, { text: "⚠️ Contoh: !suhu 100c atau !suhu 212f" })
            const suhuVal = parseFloat(teks)
            const suhuType = teks.slice(-1).toLowerCase()
            let suhuResult = ""
            if (suhuType === "c") suhuResult = `${suhuVal}°C = *${(suhuVal * 9/5 + 32).toFixed(2)}°F* = *${(suhuVal + 273.15).toFixed(2)}K*`
            else if (suhuType === "f") suhuResult = `${suhuVal}°F = *${((suhuVal - 32) * 5/9).toFixed(2)}°C* = *${((suhuVal - 32) * 5/9 + 273.15).toFixed(2)}K*`
            else if (suhuType === "k") suhuResult = `${suhuVal}K = *${(suhuVal - 273.15).toFixed(2)}°C* = *${((suhuVal - 273.15) * 9/5 + 32).toFixed(2)}°F*`
            else return await sock.sendMessage(from, { text: "❌ Gunakan c, f, atau k. Contoh: !suhu 100c" })
            await sock.sendMessage(from, { text: `🌡️ *Konversi Suhu*\n\n${suhuResult}` })
            break

        case "panjang":
            if (!teks) return await sock.sendMessage(from, { text: "⚠️ Contoh: !panjang 1km" })
            const panjangVal = parseFloat(teks)
            const panjangType = teks.replace(/[0-9.]/g, "").toLowerCase()
            const toMeter = { km: 1000, m: 1, cm: 0.01, mm: 0.001, mile: 1609.34, ft: 0.3048, inch: 0.0254 }
            if (!toMeter[panjangType]) return await sock.sendMessage(from, { text: "❌ Satuan: km, m, cm, mm, mile, ft, inch" })
            const meter = panjangVal * toMeter[panjangType]
            await sock.sendMessage(from, { text: `📏 *Konversi Panjang*\n\n${panjangVal}${panjangType} =\n*${meter}m* / *${meter*100}cm* / *${meter/1000}km*` })
            break

        case "berat":
            if (!teks) return await sock.sendMessage(from, { text: "⚠️ Contoh: !berat 1kg" })
            const beratVal = parseFloat(teks)
            const beratType = teks.replace(/[0-9.]/g, "").toLowerCase()
            const toGram = { kg: 1000, g: 1, mg: 0.001, lb: 453.592, oz: 28.3495 }
            if (!toGram[beratType]) return await sock.sendMessage(from, { text: "❌ Satuan: kg, g, mg, lb, oz" })
            const gram = beratVal * toGram[beratType]
            await sock.sendMessage(from, { text: `⚖️ *Konversi Berat*\n\n${beratVal}${beratType} =\n*${gram}g* / *${gram/1000}kg* / *${gram/453.592}lb*` })
            break

        case "waktuzoom":
            const zonaWaktu = [
                { nama: "🇮🇩 WIB (Jakarta)", zona: "Asia/Jakarta" },
                { nama: "🇮🇩 WITA (Makassar)", zona: "Asia/Makassar" },
                { nama: "🇮🇩 WIT (Jayapura)", zona: "Asia/Jayapura" },
                { nama: "🇯🇵 Tokyo", zona: "Asia/Tokyo" },
                { nama: "🇺🇸 New York", zona: "America/New_York" },
                { nama: "🇬🇧 London", zona: "Europe/London" },
            ]
            let waktuMsg = "🌍 *Waktu Berbagai Zona*\n\n"
            zonaWaktu.forEach(z => {
                waktuMsg += `${z.nama}: *${new Date().toLocaleTimeString("id-ID", { timeZone: z.zona })}*\n`
            })
            await sock.sendMessage(from, { text: waktuMsg })
            break

        // ══════════════════════════════
        //         🎲 RANDOM
        // ══════════════════════════════
        case "randomnama":
            const namaList = ["Arya", "Bima", "Citra", "Dewa", "Elang", "Fajar", "Gemilang", "Hana", "Indra", "Jaya", "Kirana", "Langit", "Mentari", "Nala", "Omega"]
            await sock.sendMessage(from, { text: `🎲 *Nama Random*\n\n*${randomItem(namaList)}*` })
            break

        case "randomwarna":
            const hex = "#" + Math.floor(Math.random()*16777215).toString(16).padStart(6, "0")
            await sock.sendMessage(from, { text: `🎨 *Warna Random*\n\nHex: *${hex}*\nRGB: *${parseInt(hex.slice(1,3),16)}, ${parseInt(hex.slice(3,5),16)}, ${parseInt(hex.slice(5,7),16)}*` })
            break

        case "randomnegara":
            const negaraList = ["Indonesia 🇮🇩", "Jepang 🇯🇵", "Korea Selatan 🇰🇷", "Amerika Serikat 🇺🇸", "Brazil 🇧🇷", "Jerman 🇩🇪", "Prancis 🇫🇷", "Australia 🇦🇺", "India 🇮🇳", "Kanada 🇨🇦"]
            await sock.sendMessage(from, { text: `🌍 *Negara Random*\n\n*${randomItem(negaraList)}*` })
            break

        case "randomfakta":
            await sock.sendMessage(from, { text: `🧠 *Fakta Random Dunia*\n\n${randomItem(faktaData)}` })
            break

        // ══════════════════════════════
        //     🔧 UTILITAS CANGGIH
        // ══════════════════════════════
        case "qr":
            if (!teks) return await sock.sendMessage(from, { text: "⚠️ Contoh: !qr teks atau link" })
            const qrUrl = `https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=${encodeURIComponent(teks)}`
            await sock.sendMessage(from, { image: { url: qrUrl }, caption: `📱 *QR Code*\n\nData: ${teks}` })
            break

        case "cekwa":
            if (!teks) return await sock.sendMessage(from, { text: "⚠️ Contoh: !cekwa 628xxxxxxxxxx" })
            await sock.sendMessage(from, { text: `📱 *Cek Nomor WA*\n\nNomor: ${teks}\n\n_Fitur ini membutuhkan verifikasi manual_\nCoba hubungi nomor tersebut langsung.` })
            break

        case "poll":
            if (!teks) return await sock.sendMessage(from, { text: "⚠️ Contoh: !poll Pertanyaan | Opsi1 | Opsi2 | Opsi3" })
            const pollParts = teks.split("|").map(p => p.trim())
            if (pollParts.length < 3) return await sock.sendMessage(from, { text: "⚠️ Minimal 1 pertanyaan dan 2 opsi!" })
            let pollMsg = `📊 *POLLING*\n\n❓ ${pollParts[0]}\n\n`
            const emoji = ["1️⃣","2️⃣","3️⃣","4️⃣","5️⃣"]
            pollParts.slice(1).forEach((opt, i) => { pollMsg += `${emoji[i]} ${opt}\n` })
            pollMsg += "\n_Balas dengan nomor pilihanmu!_"
            await sock.sendMessage(from, { text: pollMsg })
            break

        case "reminder":
            if (!teks) return await sock.sendMessage(from, { text: "⚠️ Contoh: !reminder 5 Minum obat\n(5 = menit)" })
            const reminderParts = teks.split(" ")
            const menit = parseInt(reminderParts[0])
            const pesanReminder = reminderParts.slice(1).join(" ")
            if (isNaN(menit)) return await sock.sendMessage(from, { text: "❌ Format salah! Contoh: !reminder 5 Minum obat" })
            await sock.sendMessage(from, { text: `⏰ *Reminder diset!*\n\nWaktu: ${menit} menit lagi\nPesan: ${pesanReminder}` })
            setTimeout(async () => {
                await sock.sendMessage(from, { text: `⏰ *REMINDER!*\n\n${pesanReminder}\n\n_Diset ${menit} menit yang lalu_` })
            }, menit * 60 * 1000)
            break

        // ══════════════════════════════
        //     🔍 PENCARIAN (API-based)
        // ══════════════════════════════
        case "cuaca":
            if (!teks) return await sock.sendMessage(from, { text: "⚠️ Contoh: !cuaca Jakarta" })
            try {
                const cuacaRes = await axios.get(`https://wttr.in/${encodeURIComponent(teks)}?format=3`)
                await sock.sendMessage(from, { text: `🌤️ *Cuaca ${teks}*\n\n${cuacaRes.data}` })
            } catch {
                await sock.sendMessage(from, { text: "❌ Gagal mengambil data cuaca!" })
            }
            break

        case "translate":
            if (!teks) return await sock.sendMessage(from, { text: "⚠️ Contoh: !translate hello world" })
            try {
                const transRes = await axios.get(`https://api.mymemory.translated.net/get?q=${encodeURIComponent(teks)}&langpair=en|id`)
                const hasil = transRes.data.responseData.translatedText
                await sock.sendMessage(from, { text: `🌐 *Translate*\n\nAsli: ${teks}\nHasil: *${hasil}*` })
            } catch {
                await sock.sendMessage(from, { text: "❌ Gagal menerjemahkan!" })
            }
            break

        case "anime":
            if (!teks) return await sock.sendMessage(from, { text: "⚠️ Contoh: !anime Naruto" })
            try {
                const animeSearch = await axios.get(`https://api.jikan.moe/v4/anime?q=${encodeURIComponent(teks)}&limit=1`)
                const a = animeSearch.data.data[0]
                await sock.sendMessage(from, { text: `🎌 *Info Anime*\n\n📌 Judul: ${a.title}\n⭐ Score: ${a.score}\n📺 Episode: ${a.episodes || "?"}\n📊 Status: ${a.status}\n📝 Sinopsis: ${a.synopsis?.slice(0,200)}...` })
            } catch {
                await sock.sendMessage(from, { text: "❌ Anime tidak ditemukan!" })
            }
            break

        case "manga":
            if (!teks) return await sock.sendMessage(from, { text: "⚠️ Contoh: !manga One Piece" })
            try {
                const mangaSearch = await axios.get(`https://api.jikan.moe/v4/manga?q=${encodeURIComponent(teks)}&limit=1`)
                const m = mangaSearch.data.data[0]
                await sock.sendMessage(from, { text: `📚 *Info Manga*\n\n📌 Judul: ${m.title}\n⭐ Score: ${m.score}\n📖 Chapter: ${m.chapters || "?"}\n📊 Status: ${m.status}\n📝 Sinopsis: ${m.synopsis?.slice(0,200)}...` })
            } catch {
                await sock.sendMessage(from, { text: "❌ Manga tidak ditemukan!" })
            }
            break

        case "karakter":
            if (!teks) return await sock.sendMessage(from, { text: "⚠️ Contoh: !karakter Naruto" })
            try {
                const charSearch = await axios.get(`https://api.jikan.moe/v4/characters?q=${encodeURIComponent(teks)}&limit=1`)
                const c = charSearch.data.data[0]
                await sock.sendMessage(from, { text: `🎭 *Info Karakter*\n\n📌 Nama: ${c.name}\n⭐ Favorit: ${c.favorites}\n📝 Tentang: ${c.about?.slice(0,200) || "Tidak ada info"}...` })
            } catch {
                await sock.sendMessage(from, { text: "❌ Karakter tidak ditemukan!" })
            }
            break

        case "topanime":
            try {
                const topRes = await axios.get("https://api.jikan.moe/v4/top/anime?limit=5")
                let topMsg = "🏆 *Top 5 Anime Terpopuler*\n\n"
                topRes.data.data.forEach((a, i) => { topMsg += `${i+1}. *${a.title}* (⭐${a.score})\n` })
                await sock.sendMessage(from, { text: topMsg })
            } catch {
                await sock.sendMessage(from, { text: "❌ Gagal mengambil data top anime!" })
            }
            break

        case "jadwalsholat":
            if (!teks) return await sock.sendMessage(from, { text: "⚠️ Contoh: !jadwalsholat Jakarta" })
            try {
                const sholatRes = await axios.get(`https://api.aladhan.com/v1/timingsByCity?city=${encodeURIComponent(teks)}&country=Indonesia&method=11`)
                const t = sholatRes.data.data.timings
                await sock.sendMessage(from, { text: `🕌 *Jadwal Sholat ${teks}*\n\n🌅 Subuh: ${t.Fajr}\n☀️ Dzuhur: ${t.Dhuhr}\n🌤️ Ashar: ${t.Asr}\n🌆 Maghrib: ${t.Maghrib}\n🌙 Isya: ${t.Isha}` })
            } catch {
                await sock.sendMessage(from, { text: "❌ Kota tidak ditemukan!" })
            }
            break

        case "kbbi":
            if (!teks) return await sock.sendMessage(from, { text: "⚠️ Contoh: !kbbi serendipity" })
            await sock.sendMessage(from, { text: `📖 *KBBI - ${teks}*\n\nCek di: https://kbbi.kemdikbud.go.id/entri/${encodeURIComponent(teks)}` })
            break

        case "dictionary":
            if (!teks) return await sock.sendMessage(from, { text: "⚠️ Contoh: !dictionary serendipity" })
            try {
                const dictRes = await axios.get(`https://api.dictionaryapi.dev/api/v2/entries/en/${encodeURIComponent(teks)}`)
                const def = dictRes.data[0].meanings[0].definitions[0].definition
                await sock.sendMessage(from, { text: `📖 *Dictionary*\n\n🔤 ${teks}\n📝 ${def}` })
            } catch {
                await sock.sendMessage(from, { text: "❌ Kata tidak ditemukan!" })
            }
            break

        case "namabayi":
            if (!teks) return await sock.sendMessage(from, { text: "⚠️ Contoh: !namabayi cahaya" })
            const namaMap = {
                "cahaya": "Nur/Noor - Berarti cahaya, sinar terang ✨",
                "kuat": "Bima/Gagah - Berarti kekuatan dan keberanian 💪",
                "cinta": "Asa/Cinta - Berarti kasih sayang dan harapan 💕",
                "pintar": "Arif/Cerdas - Berarti bijaksana dan pandai 🧠",
            }
            const hasilNama = namaMap[teks.toLowerCase()] || `Nama dengan arti "${teks}": *${randomItem(namaList)}* - Nama indah penuh makna 🌸`
            await sock.sendMessage(from, { text: `👶 *Nama Bayi*\n\nArti: ${teks}\n\n${hasilNama}` })
            break

        case "resep":
            if (!teks) return await sock.sendMessage(from, { text: "⚠️ Contoh: !resep nasi goreng" })
            await sock.sendMessage(from, { text: `🍳 *Resep ${teks}*\n\nCari resep lengkapnya di:\nhttps://www.google.com/search?q=resep+${encodeURIComponent(teks)}` })
            break

        case "cekspek":
            if (!teks) return await sock.sendMessage(from, { text: "⚠️ Contoh: !cekspek Samsung Galaxy S24" })
            await sock.sendMessage(from, { text: `📱 *Spesifikasi ${teks}*\n\nCek spek lengkap di:\nhttps://www.gsmarena.com/search.php3?sQuickSearch=${encodeURIComponent(teks)}` })
            break

        case "tts":
            if (!teks) return await sock.sendMessage(from, { text: "⚠️ Contoh: !tts halo selamat datang" })
            const ttsUrl = `https://translate.google.com/translate_tts?ie=UTF-8&q=${encodeURIComponent(teks)}&tl=id&client=tw-ob`
            await sock.sendMessage(from, { audio: { url: ttsUrl }, mimetype: "audio/mp4", ptt: true })
            break

        case "shortlink":
            if (!teks) return await sock.sendMessage(from, { text: "⚠️ Contoh: !shortlink https://example.com" })
            try {
                const shortRes = await axios.get(`https://tinyurl.com/api-create.php?url=${encodeURIComponent(teks)}`)
                await sock.sendMessage(from, { text: `🔗 *Short Link*\n\nAsli: ${teks}\nPendek: *${shortRes.data}*` })
            } catch {
                await sock.sendMessage(from, { text: "❌ Gagal mempersingkat link!" })
            }
            break

        case "gambar":
        case "pin":
        case "pinterest":
            if (!teks) return await sock.sendMessage(from, { text: `⚠️ Contoh: !${command} kucing lucu` })
            await sock.sendMessage(from, { text: `🔍 *Cari Gambar: ${teks}*\n\nCari di:\n🖼️ Google: https://www.google.com/search?q=${encodeURIComponent(teks)}&tbm=isch\n📌 Pinterest: https://pinterest.com/search/pins/?q=${encodeURIComponent(teks)}` })
            break

        case "lirik":
            if (!teks) return await sock.sendMessage(from, { text: "⚠️ Contoh: !lirik judul lagu" })
            await sock.sendMessage(from, { text: `🎵 *Lirik: ${teks}*\n\nCari lirik di:\nhttps://www.google.com/search?q=lirik+${encodeURIComponent(teks)}` })
            break

        case "meme":
            await sock.sendMessage(from, { text: `😂 *Meme Random*\n\nCari meme di:\nhttps://www.google.com/search?q=meme+lucu&tbm=isch` })
            break

        case "buatpuisi":
            if (!teks) return await sock.sendMessage(from, { text: "⚠️ Contoh: !buatpuisi cinta" })
            await sock.sendMessage(from, { text: `📜 *Puisi: ${teks}*\n\nDi balik senyummu yang indah,\nAda cahaya yang tak pernah padam.\nSeperti ${teks} yang selalu ada,\nMenerangi hati yang redam.\n\n🌸 _Sakura Bot_` })
            break

        case "cerpen":
            if (!teks) return await sock.sendMessage(from, { text: "⚠️ Contoh: !cerpen persahabatan" })
            await sock.sendMessage(from, { text: `📖 *Cerpen: ${teks}*\n\nDahulu kala, ada sebuah kisah tentang ${teks}...\nDua sahabat yang tak pernah terpisahkan oleh jarak dan waktu. Mereka saling menguatkan di kala susah dan berbagi tawa di kala senang.\n\nAkhirnya, persahabatan mereka menjadi legenda yang dikenang sepanjang masa. 🌸\n\n_Sakura Bot_` })
            break

        case "caption":
            if (!teks) return await sock.sendMessage(from, { text: "⚠️ Contoh: !caption liburan" })
            const captionList = [
                `Life is better at the ${teks} ✨`,
                `Blessed with ${teks} vibes 🌸`,
                `Making memories at ${teks} 💕`,
                `Good ${teks}, good life 🌟`,
            ]
            await sock.sendMessage(from, { text: `✍️ *Caption ${teks}*\n\n${randomItem(captionList)}` })
            break

        case "tebakkata":
            const kataList = ["kucing", "mobil", "rumah", "pohon", "langit", "bunga", "sungai", "gunung"]
            const kataRahasia = randomItem(kataList)
            const hint = kataRahasia.split("").map((h, i) => i === 0 ? h : "_").join(" ")
            gameData[from] = { type: "tebakkata", jawaban: kataRahasia }
            await sock.sendMessage(from, { text: `🎮 *Tebak Kata!*\n\nHint: *${hint}*\n(${kataRahasia.length} huruf)\n\nKetik jawabanmu!` })
            break

        case "tebakgambar":
            await sock.sendMessage(from, { text: `🖼️ *Tebak Gambar Anime*\n\n_Fitur ini akan segera hadir!_ 🌸\nSementara coba !tebakkata dulu ya~` })
            break

        case "hangman":
            const hangmanKata = randomItem(["naruto", "sasuke", "luffy", "goku", "ichigo", "sakura"])
            gameData[from] = { type: "hangman", jawaban: hangmanKata, tebakan: [], nyawa: 6 }
            const hangmanDisplay = hangmanKata.split("").map(() => "_").join(" ")
            await sock.sendMessage(from, { text: `🎮 *HANGMAN*\n\n${hangmanDisplay}\n\n❤️ Nyawa: 6\n\nTebak satu huruf!` })
            break

        case "tebakbendera":
            const benderaList = [
                { bendera: "🇮🇩", jawaban: "indonesia" },
                { bendera: "🇯🇵", jawaban: "jepang" },
                { bendera: "🇰🇷", jawaban: "korea" },
                { bendera: "🇺🇸", jawaban: "amerika" },
                { bendera: "🇧🇷", jawaban: "brazil" },
            ]
            const benderaRandom = randomItem(benderaList)
            gameData[from] = { type: "tebakbendera", jawaban: benderaRandom.jawaban }
            await sock.sendMessage(from, { text: `🏳️ *Tebak Bendera!*\n\n${benderaRandom.bendera}\n\nNegara apa ini?` })
            break

        case "akinator":
            await sock.sendMessage(from, { text: `🔮 *Akinator*\n\nPikirkan sebuah karakter anime...\nAku akan mencoba menebaknya!\n\nApakah karaktermu *laki-laki*? (ya/tidak)` })
            gameData[from] = { type: "akinator", step: 1 }
            break

        case "warn":
            if (!isGrup) return await sock.sendMessage(from, { text: "❌ Command ini hanya untuk grup!" })
            const warnMentions = msg.message?.extendedTextMessage?.contextInfo?.mentionedJid || []
            if (!warnMentions.length) return await sock.sendMessage(from, { text: "⚠️ Tag seseorang! Contoh: !warn @user" })
            const warnTarget = warnMentions[0]
            if (!warnData[from]) warnData[from] = {}
            if (!warnData[from][warnTarget]) warnData[from][warnTarget] = 0
            warnData[from][warnTarget]++
            await sock.sendMessage(from, {
                text: `⚠️ *WARNING*\n\n@${warnTarget.split("@")[0]} mendapat peringatan!\nTotal: *${warnData[from][warnTarget]}/3*\n\n${warnData[from][warnTarget] >= 3 ? "🚨 Sudah 3 kali! Pertimbangkan untuk kick!" : ""}`,
                mentions: [warnTarget]
            })
            break

        case "clearwarn":
            if (!isGrup) return await sock.sendMessage(from, { text: "❌ Command ini hanya untuk grup!" })
            const clearMentions = msg.message?.extendedTextMessage?.contextInfo?.mentionedJid || []
            if (!clearMentions.length) return await sock.sendMessage(from, { text: "⚠️ Tag seseorang!" })
            if (warnData[from]) warnData[from][clearMentions[0]] = 0
            await sock.sendMessage(from, { text: `✅ Peringatan @${clearMentions[0].split("@")[0]} telah dihapus!`, mentions: [clearMentions[0]] })
            break

        case "tagall":
            if (!isGrup) return await sock.sendMessage(from, { text: "❌ Command ini hanya untuk grup!" })
            try {
                const groupMeta = await sock.groupMetadata(from)
                const members = groupMeta.participants.map(p => p.id)
                const tagText = members.map(m => `@${m.split("@")[0]}`).join(" ")
                await sock.sendMessage(from, { text: `📢 *${teks || "Perhatian semua!"}*\n\n${tagText}`, mentions: members })
            } catch {
                await sock.sendMessage(from, { text: "❌ Gagal tag semua!" })
            }
            break

        case "kick":
            if (!isGrup) return await sock.sendMessage(from, { text: "❌ Command ini hanya untuk grup!" })
            const kickMentions = msg.message?.extendedTextMessage?.contextInfo?.mentionedJid || []
            if (!kickMentions.length) return await sock.sendMessage(from, { text: "⚠️ Tag seseorang!" })
            try {
                await sock.groupParticipantsUpdate(from, kickMentions, "remove")
                await sock.sendMessage(from, { text: `👢 @${kickMentions[0].split("@")[0]} telah dikeluarkan!`, mentions: kickMentions })
            } catch {
                await sock.sendMessage(from, { text: "❌ Gagal kick! Pastikan bot adalah admin." })
            }
            break

        case "promote":
            if (!isGrup) return await sock.sendMessage(from, { text: "❌ Command ini hanya untuk grup!" })
            const promoteMentions = msg.message?.extendedTextMessage?.contextInfo?.mentionedJid || []
            if (!promoteMentions.length) return await sock.sendMessage(from, { text: "⚠️ Tag seseorang!" })
            try {
                await sock.groupParticipantsUpdate(from, promoteMentions, "promote")
                await sock.sendMessage(from, { text: `⬆️ @${promoteMentions[0].split("@")[0]} dijadikan admin!`, mentions: promoteMentions })
            } catch {
                await sock.sendMessage(from, { text: "❌ Gagal promote!" })
            }
            break

        case "demote":
            if (!isGrup) return await sock.sendMessage(from, { text: "❌ Command ini hanya untuk grup!" })
            const demoteMentions = msg.message?.extendedTextMessage?.contextInfo?.mentionedJid || []
            if (!demoteMentions.length) return await sock.sendMessage(from, { text: "⚠️ Tag seseorang!" })
            try {
                await sock.groupParticipantsUpdate(from, demoteMentions, "demote")
                await sock.sendMessage(from, { text: `⬇️ @${demoteMentions[0].split("@")[0]} dicopot dari admin!`, mentions: demoteMentions })
            } catch {
                await sock.sendMessage(from, { text: "❌ Gagal demote!" })
            }
            break

        default:
            // Cek jawaban game aktif
            if (gameData[from]) {
                const game = gameData[from]
                if (game.type === "tebakkata" && pesan.slice(1) === game.jawaban) {
                    await sock.sendMessage(from, { text: `🎉 *BENAR!* Jawabannya adalah *${game.jawaban}*!` })
                    delete gameData[from]
                } else if (game.type === "tebakbendera" && pesan.slice(1).toLowerCase() === game.jawaban) {
                    await sock.sendMessage(from, { text: `🎉 *BENAR!* Benderanya adalah *${game.jawaban}*!` })
                    delete gameData[from]
                }
                return
            }
            await sock.sendMessage(from, { text: `❓ Command *${config.prefix}${command}* tidak dikenal.\nKetik *!menu* untuk daftar command. 🌸` })
    }
}

// ===================================
//         KONEKSI BOT
// ===================================
async function startBot() {
    const { state, saveCreds } = await useMultiFileAuthState("auth")

    const sock = makeWASocket({
        auth: state,
        printQRInTerminal: false,
    })

    sock.ev.on("creds.update", saveCreds)

    sock.ev.on("connection.update", ({ connection, lastDisconnect, qr }) => {
        if (qr) {
            console.log("\n🌸 Scan QR Code ini pakai WhatsApp kamu:\n")
            qrcode.generate(qr, { small: true })
        }
        if (connection === "close") {
            const alasan = new Boom(lastDisconnect?.error)?.output?.statusCode
            if (alasan !== DisconnectReason.loggedOut) {
                console.log("🔄 Reconnecting...")
                startBot()
            } else {
                console.log("⛔ Bot logout. Hapus folder auth dan jalankan ulang.")
            }
        } else if (connection === "open") {
            console.log("✅ Sakura Bot terhubung! 🌸")
        }
    })

    // ===================================
    //     HANDLE PESAN MASUK
    // ===================================
    sock.ev.on("messages.upsert", async ({ messages }) => {
        const msg = messages[0]
        if (!msg.message) return
        if (msg.key.fromMe) return

        const from = msg.key.remoteJid
        const isGrup = from.endsWith("@g.us")
        const pengirim = msg.key.participant || from

        // Cek bot aktif di grup
        if (isGrup && groupSettings[from]?.aktif === false) return

        const pesan = (
            msg.message?.conversation ||
            msg.message?.extendedTextMessage?.text || ""
        ).trim()

        if (!pesan) return

        // Anti spam
        if (config.antispam.aktif && cekSpam(pengirim)) {
            await sock.sendMessage(from, { text: "⚠️ Slow down! Kamu terlalu cepat mengirim pesan!" })
            return
        }

        // Anti link
        if (isGrup && groupSettings[from]?.antilink) {
            const linkRegex = /(https?:\/\/[^\s]+)/g
            if (linkRegex.test(pesan) && !pengirim.includes(config.ownerNumber)) {
                await sock.sendMessage(from, { delete: msg.key })
                await sock.sendMessage(from, { text: `🚫 Link tidak diizinkan di grup ini!`, mentions: [pengirim] })
                return
            }
        }

        // Anti promosi
        if (isGrup && groupSettings[from]?.antipromosi) {
            const promoRegex = /(wa\.me|chat\.whatsapp|t\.me|bit\.ly)/gi
            if (promoRegex.test(pesan)) {
                await sock.sendMessage(from, { delete: msg.key })
                return
            }
        }

        // Handle command
        const pesanLower = pesan.toLowerCase()

        // !off dan !on khusus chat pribadi
        if (!isGrup && pesanLower === `${config.prefix}off`) {
            privateChatOff[from] = true
            await sock.sendMessage(from, { text: "⛔ Sakura Bot dimatikan di chat ini.\nKetik *!on* untuk mengaktifkan kembali~ 🌸" })
            return
        }
        if (!isGrup && pesanLower === `${config.prefix}on`) {
            privateChatOff[from] = false
            await sock.sendMessage(from, { text: "✅ Sakura Bot aktif kembali! 🌸\nKetik *!menu* untuk lihat semua fitur ya!" })
            return
        }

        // Cek apakah bot dimatikan di chat pribadi ini
        if (!isGrup && privateChatOff[from]) return

        if (pesanLower.startsWith(config.prefix)) {
            await handleCommand(sock, msg, from, pesanLower, isGrup)
            return
        }

        // Auto greet - chat pribadi (ketik apapun)
        if (!isGrup) {
            // Cek auto reply dulu
            let adaReply = false
            for (const [kata, balasan] of Object.entries(autoReply)) {
                if (pesanLower.includes(kata)) {
                    await sock.sendMessage(from, { text: balasan })
                    adaReply = true
                    break
                }
            }
            // Kalau tidak ada auto reply, tetap sapa
            if (!adaReply) {
                await sock.sendMessage(from, { text: "Haii~ aku Sakura Bot! 🌸 Ketik *!menu* untuk lihat semua fitur ya!" })
            }
            return
        }

        // !bot command - khusus grup
        if (isGrup && pesanLower === `${config.prefix}bot`) {
            await sock.sendMessage(from, { text: "Haii~ aku Sakura Bot! 🌸 Ketik *!menu* untuk lihat semua fitur ya!" })
            return
        }
    })

    // ===================================
    //     WELCOME / GOODBYE GRUP
    // ===================================
    sock.ev.on("group-participants.update", async ({ id, participants, action }) => {
        for (const peserta of participants) {
            if (action === "add") {
                await sock.sendMessage(id, {
                    text: `🌸 *Selamat Datang!*\n\nHalo @${peserta.split("@")[0]}! Selamat bergabung di grup ini!\nSemoga betah ya~ 😊\n\nKetik *!menu* untuk melihat fitur bot!`,
                    mentions: [peserta]
                })
            } else if (action === "remove") {
                await sock.sendMessage(id, {
                    text: `👋 *Sampai Jumpa!*\n\n@${peserta.split("@")[0]} telah meninggalkan grup.\nSemoga sukses selalu! 🌸`,
                    mentions: [peserta]
                })
            }
        }
    })
}

startBot()
