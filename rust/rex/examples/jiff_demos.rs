use jiff::{
    civil::{date, Date}, tz::TimeZone, ToSpan, Zoned
};
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize)]
struct Obj {
    datetime: Zoned,
}

fn main() -> Result<(), jiff::Error> {
    let zdt = date(2024, 3, 1).intz("America/New_York")?;
    assert_eq!(
        format!("{}", zdt),
        "2024-03-01T00:00:00-05:00[America/New_York]"
    );
    assert_eq!(
        format!("{}", zdt.strftime("%Y-%m-%d %H:%M:%S.000%:z")),
        "2024-03-01 00:00:00.000-05:00"
    );

    let ms = zdt.timestamp().as_millisecond();
    println!("Millis since epoch: {}", ms); // 1709269200000
    println!(
        "{}",
        Zoned::new(zdt.timestamp(), TimeZone::get("America/New_York").unwrap())
    );

    // Parse a string to a date
    let d1: Date = "2024-03-01".parse()?;
    assert_eq!(d1, date(2024, 3, 1));

    // Serialize to json
    let obj = Obj {
        datetime: date(2024, 3, 1).intz("America/New_York")?,
    };

    //======================================================================================
    // Work with dates
    //  

    // Convert number of days since 1970-01-01 to a date
    let epoch_zero = Date::ZERO.saturating_add(719528.days());
    assert_eq!(date(1970, 1, 1), epoch_zero);

    let start = date(2024, 1, 3);
    println!("{:?} = {}", start.weekday(), start.weekday().to_monday_zero_offset());


    Ok(())
}
