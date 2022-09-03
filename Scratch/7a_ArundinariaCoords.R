# This script should be run via the R docker container (arundinaRia) after you have sourced the
# container paths in 0_Paths.env and 0_Containers.env. You can either execute it with ${_arundinaRia[@]}
# followed by the DOCKER path to the script or interactively run the container by replacing the
# `--entrypoint` command and adding `-it`

library(tidyverse)

# Create list of coordinates from PDF
ArundinariaCoords <- list()
ArundinariaCoords["A.appalachiana"] <- "Triplett  Weakley   &   L.G.  Clark   —    Triplett  and  L.G.  Clark  19 ,  GQ468314,  Macon  Co.,  NC,  35.0168,  83.3882,  ISC;  Triplett  and  L.G.  Clark  20 ,  GQ468315,  Rabun  Co.,  GA,  34.9576,  83.1806, ISC;  Triplett and L.G. Clark 21 , GQ468316, Jackson Co., NC,  35.3898,  83.1981,  ISC;   Triplett  and  Ozaki  99 ,  FJ644129,  Dekalb  Co.,  AL, 34.5005, 85.6352, ISC;  Triplett and Ozaki 100 , GQ468317, Dekalb  Co.,  AL,  34.4973,  85.6337,  ISC;   Triplett  and  Ozaki  102 ,  GQ468318,  cultivated,  n/a,  n/a,  ISC;   Triplett  and  Ozaki  103 ,  GQ468319,  cultivated,  n/a, n/a, ISC;  Triplett 165 , GQ468320, Polk Co., TN, 35.0421, 84.4514,  ISC;   Triplett  166 ,  GQ468321,  Bartow  Co.,  GA,  34.2456,  84.6753,  ISC;  Triplett  179 ,  GQ468322,  Greenville  Co.,  SC,  35.0851,  82.608,  ISC;  Triplett  182 ,  GQ468323,  Buncombe  Co.,  NC,  35.5673,  82.5683,  ISC;  Triplett 184 , GQ468324, Swain Co., NC, 35.4469, 83.4251, ISC;  Triplett  185 , GQ468325, Graham Co., NC, 35.3827, 83.8623, ISC;  Triplett 188 ,  GQ468326, Rhea Co., TN, 35.7418, 84.8392, ISC."
ArundinariaCoords["A.gigantea"] <- "Triplett and L.G. Clark 1  , GQ468327,  Gadsden  Co.,  FL,  30.6512,  84.8721,  ISC;   Triplett  and  L.G.  Clark  2 ,  GQ468328,  Gadsden  Co.,  FL,  30.6512,  84.8721,  ISC;   Triplett  and  L.G.  Clark 3 , GQ468329, Jackson Co., FL, 30.6995, 84.8607, ISC;  Triplett and  L.G. Clark 4 , GQ468330, Decatur Co., GA, 30.757, 84.7857, ISC;  Triplett  and L.G. Clark 5 , GQ468331, Gadsden Co., FL, 30.6977, 84.8497, ISC;  Triplett and L.G. Clark 6 , GQ468332, Taylor Co., GA, 32.5426, 84.0184,  ISC;   Triplett  and  L.G.  Clark  18 ,  GQ468333,  Macon  Co.,  NC,  35.1861,  83.3723, ISC;  Triplett and Ozaki 80 , GQ468334, Marion Co., AR, 36.2421,  92.7667, ISC;  Triplett and Ozaki 81 , GQ468335, Pope Co., AR, 35.4109,  93.1328, ISC;  Triplett and Ozaki 82 , GQ468336, Perry Co., AR, 34.8698,  93.1093, ISC;  Triplett and Ozaki 83 , GQ468337, Grant Co., AR, 34.3074,  92.2163,  ISC;   Triplett  and  Ozaki  84 ,  GQ468338,  Lincoln  Co.,  AR,  33.9545, 91.8439, ISC;  Triplett and Ozaki 85 , GQ468339, Columbia Co.,  AR,  33.2695,  93.272,  ISC;   Triplett  and  Ozaki  86 ,  GQ468340,  Bienville  Parish,  LA,  32.5054,  92.8744,  ISC;   Triplett  and  Ozaki  87 ,  GQ468341,  Evangeline  Parish,  LA,  30.8003,  92.281,  ISC;   Triplett  and  Ozaki  88 ,  GQ468342,  St.  Martin  Parish,  LA,  30.2937,  91.918,  ISC;   Triplett  and  Ozaki 91 , GQ468343, Rankin Co., MS, 32.204, 90.0513, ISC;  Triplett and  Ozaki 92 , GQ468344, Hinds Co., MS, 32.2818, 90.183, ISC;  Triplett and  Ozaki 93 , GQ468345, Grenada Co., MS, 33.8065, 89.7415, ISC;  Triplett  and  Ozaki  94 ,  GQ468346,  Carroll  Co.,  MS,  33.6364,  89.7963,  ISC;  Triplett and Ozaki 95 , GQ468347, Clay Co., MS, 33.5419, 88.6345, ISC;  Triplett and Ozaki 96 , GQ468348, Tuscaloosa Co., AL, 33.1146, 87.596,  ISC;  Triplett and Ozaki 98 , GQ468349, Lee Co., AL, 32.5669, 85.3772,  ISC;   Triplett  and  Ozaki  101 ,  GQ468350,  cultivated  (approximate  wild  locality: Macon Co., GA, 36.4599, 85.9938), ISC;  Triplett 108 , GQ468351,  Jackson Co., IL, 37.627, 89.2087, ISC;  Triplett 109 , GQ468352, Alexander  Co.,  IL,  37.1209,  89.2737,  ISC;   Triplett  110 ,  GQ468353,  Marshall  Co.,  KY,  36.8565,  88.3156,  ISC;   Triplett  111 ,  GQ468354,  Hickman  Co.,  TN,  35.6638,  87.6908,  ISC;   Triplett  112 ,  GQ468355,  McNairy  Co.,  TN,  35.2119,  88.3949,  ISC;   Triplett  164 ,  GQ468356,  Hamilton  Co.,  TN,  35.0775,  85.0394,  ISC;   Triplett  167 ,  GQ468357,  Bartow  Co.,  GA,34.149, 84.8443, ISC;  Triplett 169 , GQ468358, Oconee Co., GA, 33.724,  83.3849,  ISC;   Triplett  174 ,  GQ468359,  Greenwood  Co.,  SC,  34.1586,  81.946,  ISC;   Triplett  177 ,  GQ468360,  Cherokee  Co.,  SC,  35.1234,  81.588,  ISC;   Triplett  180 ,  GQ468361,  Buncombe  Co.,  NC,  35.4644,  82.4586,  ISC;   Triplett  181 ,  GQ468362,  Buncombe  Co.,  NC,  35.5634,  82.5622, ISC;  Triplett 183 , GQ468363, Swain Co., NC, 35.4337, 83.4388,  ISC;   Triplett  186 ,  GQ468364,  Swain  Co.,  NC,  35.4501,  83.9407,  ISC;  Triplett 187 , GQ468365, Monroe Co., TN, 35.565, 84.0933, ISC;  Triplett  189 ,  GQ468366,  Scott  Co.,  TN,  36.3145,  84.6271,  ISC;   Triplett  190 ,  GQ468367, Adair Co., KY, 37.1932, 85.3459, ISC;  Triplett and Campbell  191 ,  GQ468368,  Garrard  Co.,  KY,  37.8083,  84.6568,  ISC;   Triplett  and  Campbell  192 ,  GQ468369,  Jessamine  Co.,  KY,  37.8448,  84.5836,  ISC;  Triplett and Campbell 195 , GQ468370, Fayette Co., KY, 38.073, 84.5363,  ISC;   Triplett  and  Campbell  196 ,  GQ468371,  cultivated,  Fayette  Co.,  KY, n/a, n/a, ISC;  Triplett 197 , FJ644131, Switzerland Co., IN, 38.7679,  85.1451, ISC;  Triplett 198 , GQ468372, Gibson Co., IN, 38.3477, 87.8024,  ISC;   Triplett  and  Zhang  291 ,  GQ468373-GQ468376,  Marion  Co.,  AR,  36.2436, 92.7694, ISC."
ArundinariaCoords["A.tecta"] <- "Triplett and L.G. Clark 22 , GQ468387,  Wayne  Co.,  NC,  35.4195,  78.0506,  ISC;   Triplett  and  L.G.  Clark  23 ,  GQ468388,  Craven  Co.,  NC,  35.1078,  77.0153,  ISC;   Triplett  and  L.G.  Clark  24 ,  GQ468389,  Craven  Co.,  NC,  35.2603,  77.1011,  ISC;   Triplett  and  L.G.  Clark  25 ,  GQ468390,  Suffolk  City/Great  Dismal  Swamp, VA,  36.599,  76.5282,  ISC;   Triplett  and  L.G.  Clark  26 ,  GQ468391,  Suffolk  City/Great Dismal Swamp, VA, 36.6214, 76.5403, ISC;  Triplett and L.G.  Clark 27 , GQ468392, Chatham Co., GA, 31.999, 81.2682, ISC;  Triplett  170 , GQ468393, McDuffi e Co., GA, 33.4122, 82.3818, ISC;  Triplett 173 ,  FJ644132, Aiken Co., SC, 33.646, 81.2143, ISC"
ArundinariaCoords["A. hybrid"] <- "Triplett and L.G. Clark 8 , GQ468377, Macon  Co., GA, 32.4894, 83.9378, ISC;  Triplett and Ozaki 89 , GQ468378, Pearl  River Co., MS, 30.7114, 89.5553, ISC;  Triplett and Ozaki 90 , GQ468379,  Forrest Co., MS, 31.4156, 89.2806, ISC;  Triplett and Ozaki 97 , GQ468380,  Lee  Co.,  AL,  32.5451,  85.3885,  ISC;   Triplett  168 ,  GQ468381,  Greene  Co.,  GA,  33.7116,  83.3033,  ISC;   Triplett  171 ,  GQ468382,  Jenkins  Co.,  GA,  32.7734,  81.9227,  ISC;   Triplett  172 ,  GQ468383,  Screven  Co.,  GA,  32.9401,  81.4955,  ISC;   Triplett  175 ,  GQ468384,  Laurens  Co.,  SC,  34.5031,  81.8121,  ISC;   Triplett  176 ,  GQ468385,  Laurens  Co.,  SC,  34.5028,  81.8115,  ISC;   Triplett  178 ,  GQ468386,  Greenville  Co.,  SC,  34.8649, 82.419, ISC"

map(
  ArundinariaCoords,
  function(species) {
    # Parse and remove white space and other problem chars
    species %>%
      str_split(pattern = ";") %>%
      pluck(1) %>%
      str_trim() %>%
      str_split(pattern = ",", simplify = TRUE) %>%
      as_tibble() %>%
      select(c(1, 5, 6)) %>%
      mutate(across(.fns = str_trim),
        V6 = gsub(")", "", V6)
      )
  }
) %>%
  # Add Species info
  bind_rows(.id = "Species") %>%
  # Convert names to IDs
  # Convert lat/long to numbers and make long negative
  mutate(
    V1 = str_extract(V1, "\\d+$"),
    V1 = paste0("JT", V1),
    across(c(V5, V6), as.numeric),
    V6 = V6 * -1
  ) %>%
  # Clean NA
  na.omit() %>%
  # Reorganize
  rename(Sample = V1, Latitute = V5, Longitude = V6) %>%
  relocate(Species = Species, .after = Longitude) %>%
  write.csv(file = "/mnt/References/JTCoords.csv", row.names = FALSE)
