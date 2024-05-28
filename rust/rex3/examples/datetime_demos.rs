use chrono::prelude::*;
use chrono::{DateTime, Datelike, NaiveDate, NaiveDateTime, NaiveTime};
use chrono_tz::America::{Los_Angeles, New_York};
use chrono_tz::Tz;

fn main() {
    let day = NaiveDate::from_ymd_opt(1970, 1, 1).unwrap();
    println!("Number of days from 1/1/0001 to 1/1/1970 is {}", day.num_days_from_ce());
    
    // there are 719163 days from 0001-01-01 to 1970-01-01
    //            19863 days from 1970-01-01 to 2024-05-20
    let day = NaiveDate::from_num_days_from_ce_opt(719163 + 19863).unwrap();
    assert_eq!(day, NaiveDate::from_ymd_opt(2024, 5, 20).unwrap());

    println!("Convert to DateTime UTC from microseconds since 1970-01-01");
    let dt = DateTime::from_timestamp_millis(1714554674000).unwrap();
    assert_eq!(dt, NaiveDate::from_ymd_opt(2024, 5, 1).unwrap().and_hms_opt(9, 11, 14).unwrap().and_utc());
    assert_eq!(dt.to_rfc3339_opts(chrono::SecondsFormat::Secs, true), "2024-05-01T09:11:14Z");
    println!("{}", dt);

    println!("\nConvert from microseconds since 1970-01-01 to America/New_York");
    let dt = New_York.timestamp_millis_opt(1714554674000).unwrap();
    println!("From millis to {}", dt.to_rfc3339_opts(SecondsFormat::Secs, true));

    println!("\nConvert from microseconds since 1970-01-01 to America/Los_Angeles");
    let dt = Los_Angeles.timestamp_millis_opt(1714554674000).unwrap();
    println!("From millis to {}", dt.to_rfc3339_opts(SecondsFormat::Secs, true));

    println!("\nCreate a datetime from naive date time");
    let naive_dt = NaiveDateTime::new(day, NaiveTime::from_num_seconds_from_midnight_opt(0,0).unwrap());
    let dt = New_York.from_local_datetime(&naive_dt).unwrap();
    assert_eq!(dt.to_rfc3339(), "2024-05-20T00:00:00-04:00");

    let tz = "America/New_York".parse::<Tz>().unwrap();
    let dt = tz.from_utc_datetime(&naive_dt);
    assert_eq!(dt.to_rfc3339_opts(SecondsFormat::Secs, true), "2024-05-19T20:00:00-04:00");

}

