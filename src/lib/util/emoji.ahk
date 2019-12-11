#NoEnv  ; Uyumlukuk için A_ ön eki ile ortam değişkenlerini kullanın
#SingleInstance Force ; Sadece 1 kez açalıştırabilire

#KeyHistory 0 ; Tuş basımları loglamayı engeller

SetBatchLines, -1 ; Scripti sürekli olarak çalıştırma (nromalde her saniye 10ms uyur)
ListLines, Off ; Derlenen verileri loglamaz

#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#MaxThreadsPerHotkey, 1 ; Yanlışlıkla 2 kere buton algılanmasını engeller
#Hotstring EndChars : ; Bitirme karakteri
#Hotstring r Z C0 O ; Algılama ayarları

; Yakın zamanda kullandıklarım
:::inşaat::🚧
:::yapı::🏗️
:::hız::💨
:::merak::👀
:::gözm::👀
:::geridönüşüm::♻️
:::denge::⚖️
:::parti::🎉
:::kurukafa::☠️
:::takvim::📅w
:::takvimn::📆
:::takvims::🗓️
:::polis::👮‍♂️
:::hortum::🌪️
:::alev::🔥
:::çeviri::💱
:::dönüştürme::🔄
:::yılan::🐍
:::pc::💻
:::bilgisayar::💻
:::para::💰
:::saat::🕐
:::alarm::⏰
:::saatk::⌚
:::öğretmen::👨‍🏫
:::kitap::📖
:::kitaplar::📚
:::kitapk::📕
:::kitapm::📘
:::kitapy::📗
:::kitapt::📙
:::gemi::🛳️
:::gazete::📰
:::lisans::©️

; Hızlı emojiler
:::eli::🤭

; Kod için hızlı emojiler

:::tren::🚅
:::dizi::🚅
:::link::🔗
:::beyin::🧠

; Duygular
::::)::😊
::::/::😕
:::://::🤕
::::'D::😅
::::D::😁
::::O::😯
::::OO::😱
::::(::☹️
:::zzz::😴
:::sarılma::🤗
:::gözy::🙄
:::rahatlama::😌
:::uyuklama::😴
::::p::😋
:::kutlama::🥳
:::imalı::😏
:::keyifsiz::😒
:::lezzetli::😋

:::güneş::☀️
:::güneşg::🌞

; Matematik
:::+::➕
:::-::➖
:::x::✖️
:::\::➗

; İşaretler
:::onay::✔️
:::onayb::✅
:::onayb2::☑️
:::red::❌
:::redb::❎
:::başlat::▶️
:::raptiye::📌
:::!::❗

; Geliştirici
:::bug::🐞
:::böcek::🐞
:::debug::🐛
:::dosya::📂
:::dizin::🗂️

:::telefon::📞
:::ahtapot::🐙
:::not::📝

:::kılıç::⚔️
:::koş::🏃‍♂️
:::patlama::💥
:::yay::🏹

; Bilgisayar bileşenleri

:::klavye::⌨️
:::mouse::🖱️

; YEmoji
:::döngü::💫
:::tuğla::🧱
:::duvar::🧱
:::yıldız::⭐
:::fav::🌟
:::kod::👨‍💻
:::fişek::🎇
:::harf::🔡
:::karo::💠
:::elmas::💎

:::beyinp::🤯
:::bağlantı::🔗
:::gece::🌃
:::manzara::🌆
:::sarhoş::🥴
:::buton::🎛️
:::dişli::⚙️
:::vida::🔩
:::ampul::💡
:::müzik::🎶
:::hoperlör::🔉
:::yönetici::👨‍💼
:::yapboz::🧩
:::çadır::⛺
:::güneş::🌞
:::sinyal::📶
:::japon::🔰
:::parlak::🔆
:::kutu::🧃
::dal::🔀
:::anahtar::🔑
:::kilit::🔏
:::parşomen::📜
:::parıltı::✨
:::meraklı::👀
:::bulut::⛅
:::dağ::🌄
:::mızrak::🔱
:::grafiky::📈
:::grafik+::📈
:::grafika::📉
:::grafik-::📉
:::grafiks::📊
:::grafik=::📊
:::sayfa::📃
:::kıvrık::➰
:::çubuk::🍢
:::fiş::🔌
:::voltaj::⚡
:::yasak::⛔
:::girilmez::🚫
:::resim::🖼️
:::arama::🔍
:::arama2::🔎
:::abc::🔤
:::süpürge::🧹
:::kurdele::🎀
:::übayrak::🚩
:::tamir::👨‍🔧
:::alet::🧰
:::düşünceli::🤔
:::sanat::🎨
:::bbayrak::🏁
:::çbayrak::🎌
:::roket::🚀
:::kumsaati::⌛
:::yazı::✍
:::robot::🤖
:::dalgıç::🤿
:::anlaşma::🤝
:::elkaldırma::🙋‍♂️
:::mikrofon::🎤
:::gözlüklü::🧐
:::dünya::🌍
:::okul::🏫
:::zar::🎲
:::?::❔
:::yükleme::⏫
:::indirme::⏬
:::kalp::💖
:::skalp::🖤
:::ykalp::💚
:::sarıkalp::💛
:::mkalp::💜
:::kırıkkalp::💔
:::kiraz::🍒
:::pano::📋
:::sirk::🎪
:::deney::🧪
:::civciv::🐥
:::ycivciv::🐣
:::göz::👁️
:::çember::⭕
:::kavhe::☕
:::2parmak::🤞
:::megafon::📢
:::çekiç::🔨
:::balon::🎈
:::disk::💿
:::uzay::🌌
:::top1::🏈
:::top2::🏀
:::top3::⚾
:::top4::🏐
:::pinpon::🏓
:::top5::🏉
:::iplik::🧶
:::top6::🥎
:::alışveriş::🛒
:::atom::⚛️
:::fide::🌱
:::büyücü::‍🧙‍♂
:::adım::👣
:::etiket::🏷️
