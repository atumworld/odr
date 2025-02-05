#' Jitter OD data using the Rust crate odjitter
#'
#' @param od Origin-destination data
#' @param zones Zones with `zone_name_key` corresponding to columns in `od`
#' @param subpoints Geographic dataset from which jittered desire lines start and end
#' @param zone_name_key The name of the key linking zones to the `od` data
#' @param origin_key The name of the column in the OD data representing origins
#' @param destination_key OD data column representing zone of destination
#' @param subpoints_origins Geographic dataset from which jittered desire lines start 
#' @param subpoints_destinations Geographic dataset from which jittered desire lines end
#' @param disaggregation_key The name of the column in the OD dataset determining disaggregation
#' @param disaggregation_threshold What's the maximum number of trips per output OD row that's allowed?
#' @param min_distance_meters Minimum distance between OD pairs
#' @param rng_seed Integer for deterministic jittering
#' @param weight_key_destinations Column in `subpoints_destinations` with weights
#' @param weight_key_origins Column in `subpoints_origins` with weights
#' @param od_csv_path Where the CSV file is stored (usually irrelevant)
#' @param output_path Where to save the output (usually irrelevant)
#' @param subpoints_destinations_path Location of subpoints file (usually irrelevant)
#' @param subpoints_origins_path Location of subpoints file (usually irrelevant)
#' @param zones_path Path to zones (usually irrelevant)
#' @return
#' @export
#'
#' @examples
#' od = readr::read_csv("https://github.com/dabreegster/odjitter/raw/main/data/od.csv")
#' zones = sf::read_sf("https://github.com/dabreegster/odjitter/raw/main/data/zones.geojson")
#' road_network = sf::read_sf("https://github.com/dabreegster/odjitter/raw/main/data/road_network.geojson")
#' od_jittered = odr_jitter(
#'   od,
#'   zones,
#'   subpoints = road_network,
#'   disaggregation_threshold = 50
#' )
odr_jitter = function(
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
    rng_seed = round(runif(n = 1) * 1e5),
    od_csv_path = NULL,
    output_path = NULL,
    subpoints_origins_path = NULL,
    subpoints_destinations_path = NULL,
    zones_path = NULL,
    data_dir = tempdir()
    ) {
  
  # assigning null variables to appropriate values
  if(is.null(zone_name_key)) zone_name_key = names(zones)[1]
  if(is.null(origin_key)) origin_key = names(od)[1]
  if(is.null(destination_key)) destination_key = names(od)[2]
  
  if(is.null(od_csv_path)) od_csv_path = file.path(data_dir, "od.csv")
  if(is.null(zones_path)) zones_path = file.path(data_dir, "zones.geojson")
  if(!is.null(subpoints)) {
    subpoints_origins_path = subpoints_destinations_path = file.path(data_dir, "subpoints.geojson")
    sf::write_sf(subpoints, subpoints_origins_path, delete_dsn = TRUE)
  } else {
    subpoints_origins_path = file.path(data_dir, "subpoints_origins.geojson")
    sf::write_sf(subpoints_origins, subpoints_origins_path, delete_dsn = TRUE)
    subpoints_destinations_path = file.path(data_dir, "subpoints_destinations.geojson")
    sf::write_sf(subpoints_destinations, subpoints_destinations_path, delete_dsn = TRUE)
  }
  if(is.null(output_path)) {
    output_path = file.path(data_dir, "od_jittered.geojson")
  }
  readr::write_csv(od, od_csv_path)
  sf::write_sf(zones, file.path(data_dir, "zones.geojson"), delete_dsn = TRUE)
  
  msg = glue::glue("odjitter jitter --od-csv-path {od_csv_path} \\
  --zones-path {zones_path} \\
  --zone-name-key {zone_name_key} \\
  --origin-key {origin_key} \\
  --destination-key {destination_key} \\
  --subpoints-origins-path {subpoints_origins_path} \\
  --subpoints-destinations-path {subpoints_destinations_path} \\
  --disaggregation-key {disaggregation_key} \\
  --disaggregation-threshold {disaggregation_threshold} \\
  --rng-seed {rng_seed} \\
  --output-path {output_path}")
  system(msg)
  res = sf::read_sf(output_path)
  res[names(od)]
}
