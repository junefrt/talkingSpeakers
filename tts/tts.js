const fs = require('fs');
const request = require('request');
const text = process.argv[2];
//const text = process.stdout;

const options = {
    //url: `https://translate.google.com/translate_tts?ie=UTF-8&q=${encodeURIComponent(text)}&tl=en&client=tw-ob`,
    url: `https://translate.google.com/translate_tts?ie=UTF-8&q=${encodeURIComponent(text)}&tl=fr_fr&client=tw-ob`,

    headers: {
        'Referer': 'http://translate.google.com/',
        'User-Agent': 'stagefright/1.2 (Linux;Android 5.0)'
    }
}

request(options)
    .pipe(fs.createWriteStream('tts.mp3'))
