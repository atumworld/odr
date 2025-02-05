% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/odr_jitter.R
\name{odr_jitter}
\alias{odr_jitter}
\title{Jitter OD data using the Rust crate odjitter}
\usage{
odr_jitter(
  od,
  zones,
  subpoints = NULL,
  zone_name_key = NULL,
  origin_key = NULL,
  destination_key = NULL,
  subpoints_origins = subpoints,
  subpoints_destinations = subpoints,
  disaggregation_key = "all",
  disaggregation_threshold = 10000,
  min_distance_meters = 1,
  weight_key_destinations = NULL,
  weight_key_origins = NULL,
  rng_seed = round(runif(n = 1) * 1e+05),
  od_csv_path = NULL,
  output_path = NULL,
  subpoints_origins_path = NULL,
  subpoints_destinations_path = NULL,
  zones_path = NULL,
  data_dir = tempdir()
)
}
\arguments{
\item{od}{Origin-destination data}

\item{zones}{Zones with \code{zone_name_key} corresponding to columns in \code{od}}

\item{subpoints}{Geographic dataset from which jittered desire lines start and end}

\item{zone_name_key}{The name of the key linking zones to the \code{od} data}

\item{origin_key}{The name of the column in the OD data representing origins}

\item{destination_key}{OD data column representing zone of destination}

\item{subpoints_origins}{Geographic dataset from which jittered desire lines start}

\item{subpoints_destinations}{Geographic dataset from which jittered desire lines end}

\item{disaggregation_key}{The name of the column in the OD dataset determining disaggregation}

\item{disaggregation_threshold}{What's the maximum number of trips per output OD row that's allowed?}

\item{min_distance_meters}{Minimum distance between OD pairs}

\item{weight_key_destinations}{Column in \code{subpoints_destinations} with weights}

\item{weight_key_origins}{Column in \code{subpoints_origins} with weights}

\item{rng_seed}{Integer for deterministic jittering}

\item{od_csv_path}{Where the CSV file is stored (usually irrelevant)}

\item{output_path}{Where to save the output (usually irrelevant)}

\item{subpoints_origins_path}{Location of subpoints file (usually irrelevant)}

\item{subpoints_destinations_path}{Location of subpoints file (usually irrelevant)}

\item{zones_path}{Path to zones (usually irrelevant)}
}
\value{

}
\description{
Jitter OD data using the Rust crate odjitter
}
\examples{
od = readr::read_csv("https://github.com/dabreegster/odjitter/raw/main/data/od.csv")
zones = sf::read_sf("https://github.com/dabreegster/odjitter/raw/main/data/zones.geojson")
road_network = sf::read_sf("https://github.com/dabreegster/odjitter/raw/main/data/road_network.geojson")
od_jittered = odr_jitter(
  od,
  zones,
  subpoints = road_network,
  disaggregation_threshold = 50
)
}
