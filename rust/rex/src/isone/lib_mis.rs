use std::{collections::HashMap, fs::File, path::Path};

use jiff::{
    civil::{Date, Time},
    Timestamp, Zoned,
};

struct MisReport {
    report_name: String,
    account_id: usize,
    /// As of date of the report
    report_date: Date,
    /// When the report got published
    timestamp: Timestamp,
}

#[derive(Debug, Clone)]
struct MisReportError;

impl MisReport {
    /// Parse a filename to return an MisReport.
    /// SD_RTLOAD_000000003_2017060100_20190205151707.CSV
    fn from_filename(filename: &str) -> MisReport {
        let path = Path::new(filename);
        let mut parts: Vec<&str> = path
            .file_stem()
            .unwrap()
            .to_str()
            .unwrap()
            .split("_")
            .collect();
        parts.reverse();

        // timestamp is from parts[0]
        let date = Date::strptime("%Y%m%d", parts[0].get(0..8).unwrap()).unwrap();
        let time = Time::strptime("%H%M%S", parts[0].get(8..).unwrap()).unwrap();
        let zdt = date
            .at(time.hour(), time.minute(), time.second(), 0)
            .intz("UTC")
            .unwrap();
        let timestamp = zdt.timestamp();

        let report_date = parts[1].to_string()[..8].parse::<Date>().unwrap();
        let account_id = parts[2].parse::<usize>().unwrap();
        let rn: Vec<&str> = parts[3..].iter().copied().rev().collect();
        let report_name = rn.join("_");

        MisReport {
            report_name,
            account_id,
            report_date,
            timestamp,
        }
    }

    fn read_tab(i: u8, file: File) -> Result<Vec<HashMap<String, String>>, MisReportError> {
        let res: Vec<HashMap<String, String>> = Vec::new();
        Ok(res)
    }
}

enum LocationType {
    MeteringDomain,
    NetworkNode,
}

#[derive(Debug, Clone, PartialEq, serde::Deserialize)]
struct RowSdRtloadTab0 {
  hour_beginning: u8,
  asset_name: String,
  asset_id: usize,
  asset_subtype: String, 
  location_id: usize,
  location_name: String,
  location_type: String,
  load_reading: f64,
  ownership_share: f32,
  share_of_load_reading: f64,
  subaccount_id: String,
  subaccount_name: String,
}

#[cfg(test)]
mod tests {
    use std::{error::Error, io::Read};

    use jiff::civil::Date;

    use crate::isone::lib_mis::*;

    #[test]
    fn read_report() -> Result<(), Box<dyn Error>> {
        let mut file = File::open("/home/adrian/Documents/repos/git/thumbert/elec-server/test/_assets/sd_rtload_000000003_2013060100_20140228135257.csv").unwrap();
        let mut buffer = String::new();
        file.read_to_string(&mut buffer).unwrap();

        let mut rdr = csv::Reader::from_reader(buffer.as_bytes());

        for result in rdr.records() {
            if result.as_ref().unwrap().get(0) != Some("D") {
                continue;
            }
            let record = result.expect("a CSV record");
            let row: RowSdRtloadTab0 = record.deserialize(None).unwrap();
            println!("{:?}", row);
        }
        Ok(())
    }

    #[test]
    fn from_filename() -> Result<(), Box<dyn Error>> {
        let filename = "SD_RTLOAD_000000003_2017060100_20190205151707.CSV";
        let report = MisReport::from_filename(filename);
        assert_eq!(report.report_name, "SD_RTLOAD".to_string());
        assert_eq!(report.account_id, 3);
        assert_eq!(report.report_date, "2017-06-01".parse::<Date>()?);
        assert_eq!(
            report.timestamp,
            "2019-02-05T15:17:07Z".parse::<Timestamp>()?
        );
        Ok(())
    }
}
