const cheerio = require('/usr/lib/node_modules/cheerio');

const convertNepaliToEnglishNum = (nepaliNum) => {
    switch (nepaliNum) {
        case '०': return '0';
        case '१': return '1';
        case '२': return '2';
        case '३': return '3';
        case '४': return '4';
        case '५': return '5';
        case '६': return '6';
        case '७': return '7';
        case '८': return '8';
        case '९': return '9';
        case '१०': return '10';
        case '११': return '11';
        case '१२': return '12';
        case '१३': return '13';
        case '१४': return '14';
        case '१५': return '15';
        case '१६': return '16';
        case '१७': return '17';
        case '१८': return '18';
        case '१९': return '19';
        case '२०': return '20';
        case '२१': return '21';
        case '२२': return '22';
        case '२३': return '23';
        case '२४': return '24';
        case '२५': return '25';
        case '२६': return '26';
        case '२७': return '27';
        case '२८': return '28';
        case '२९': return '29';
        case '३०': return '30';
        case '३१': return '31';
        case '३२': return '32';
        default: return null; // or throw an error, or return nepaliNum
    }
}

const convertYear = (nepaliYear) => {
    let splitYear = nepaliYear.split('');
    let englishYear = []

    // Convert each character in the year
    splitYear.forEach((item, index) => {
        englishYear.push(convertNepaliToEnglishNum(item))
    })

    // Join the array back into a string
    englishYear = englishYear.join('');

    return englishYear;
}

function nepaliMonthToEnglish(nepaliMonth) {
    if (!nepaliMonth) return null;

    // Normalize input
    nepaliMonth = nepaliMonth.trim();

    const monthMap = {
        'बैशाख': 'Baisakh',
        'वैशाख': 'Baisakh',
        'बैलेशाख': 'Baisakh',

        'जेठ': 'Jestha',
        'जेष्ठ': 'Jestha',

        'असार': 'Ashadh',
        'असाड': 'Ashadh',

        'श्रावण': 'Shrawan',
        'साउन': 'Shrawan',

        'भदौ': 'Bhadra',
        'भाद्र': 'Bhadra',

        'आश्विन': 'Ashwin',
        'आश्विन': 'Ashwin', // duplicate handled

        'कार्तिक': 'Kartik',
        'कार्तिक/कार्तिक': 'Kartik',

        'मंसिर': 'Mangsir',
        'मंसिर/मङ्सिर': 'Mangsir',

        'पुष': 'Poush',
        'पुस': 'Poush',

        'माघ': 'Magh',
        'फाल्गुण': 'Falgun',
        'फागुन': 'Falgun',

        'चैत्र': 'Chaitra',
        'चैत': 'Chaitra'
    };

    return monthMap[nepaliMonth] || null;
}

function nepaliDayToEnglish(nepaliDay) {
    if (!nepaliDay) return null;

    nepaliDay = nepaliDay.trim();

    const dayMap = {
        // Sunday
        'आइतबार': 'Sunday',
        'आइतवार': 'Sunday',

        // Monday
        'सोमबार': 'Monday',
        'सोमवार': 'Monday',

        // Tuesday
        'मंगलबार': 'Tuesday',
        'मंगलवार': 'Tuesday',

        // Wednesday
        'बुधबार': 'Wednesday',
        'बुधवार': 'Wednesday',

        // Thursday
        'बिहीबार': 'Thursday',
        'बिहीवार': 'Thursday',
        "बिहिवार": 'Thursday',

        // Friday
        'शुक्रबार': 'Friday',
        'शुक्रवार': 'Friday',

        // Saturday
        'शनिबार': 'Saturday',
        'शनिवार': 'Saturday'
    };

    return dayMap[nepaliDay] || null;
}
const scrapeAndPrintData = async () => {
    const response = await fetch('https://hamropatro.com')
    const html = await response.text();

    const $ = cheerio.load(html);
    // Example: log all headings
    let date = $('#top .nep')
    let trimmedDate = date.text().trim();

    // Get an array with 4 elements: [date, month, year, day]
    let datas = trimmedDate.split(" ");

    // Remove the comma from the year string
    datas[2] = datas[2].replace(',', '');

    // Convert all datas containing nepali characters to english characters
    datas[0] = convertNepaliToEnglishNum(datas[0]); // date
    datas[1] = nepaliMonthToEnglish(datas[1]); // month
    datas[2] = convertYear(datas[2]); // year
    datas[3] = nepaliDayToEnglish(datas[3]); // day

    let finalDatas = [datas[0], datas[1], datas[2], datas[3]];

    console.log(`\n ${finalDatas[0]} ${finalDatas[1]} ${finalDatas[2]}, ${finalDatas[3]} `);
}

scrapeAndPrintData();
