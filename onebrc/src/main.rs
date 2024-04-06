use datafusion::arrow::datatypes::{DataType, Field, Schema};
use datafusion::prelude::*;
use tokio::runtime::Runtime;

fn main() {
    // put in the path
    let path = "/Users/josiahparry/github/misc/1brc/measurements.txt";

    let rt = Runtime::new().unwrap();
    let ctx = SessionContext::new();

    let station_field = Field::new("station", DataType::Utf8, false);
    let temp_field = Field::new("temperature", DataType::Float32, false);

    let schema = Schema::new(vec![station_field, temp_field]);

    let opts = CsvReadOptions::new()
        .delimiter(b';')
        .has_header(false)
        .file_extension("txt")
        .schema(&schema);

    let df = rt.block_on(ctx.read_csv(path, opts)).unwrap();

    let results_fut = df
        .aggregate(
            vec![col("station")],
            vec![
                min(col("temperature")).alias("min_temp"),
                avg(col("temperature")).alias("mean_temp"),
                max(col("temperature")).alias("max_temp"),
            ],
        )
        .unwrap()
        .sort(vec![col("station").sort(true, false)])
        .unwrap()
        .collect();

    let results = rt.block_on(results_fut);

    let pretty = datafusion::arrow::util::pretty::pretty_format_batches(&results.unwrap()).unwrap();

    println!("{pretty}");
}
