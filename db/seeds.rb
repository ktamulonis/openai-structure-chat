puts "Seeding structured schemas..."

# Helper for adding fields cleanly
def add_field(schema, key:, type:, required: true, item_type: nil, enum_values: nil)
  schema.structured_fields.create!(
    key: key,
    data_type: type,
    required: required,
    item_type: item_type,
    enum_values: enum_values
  )
end

StructuredSchema.destroy_all

# =========================================================
# 1. Forest Mushroom Info
# =========================================================

m1 = StructuredSchema.create!(
  name: "Forest Mushroom Info",
  openai_name: "ForestMushroomInfo",
  model: "gpt-5.1",
  description: "Describes mushrooms found in forests."
)

add_field(m1, key: "name",          type: "string")
add_field(m1, key: "species",       type: "string")
add_field(m1, key: "cap_color",     type: "string")
add_field(m1, key: "edible",        type: "boolean")
add_field(m1, key: "toxicity",      type: "enum",   enum_values: "none,low,medium,high")
add_field(m1, key: "found_in",      type: "array",  item_type: "string")
add_field(m1, key: "weight_grams",  type: "float")

# =========================================================
# 2. Person Bio
# =========================================================

p1 = StructuredSchema.create!(
  name: "Person Bio",
  openai_name: "PersonBio",
  model: "gpt-5.1",
  description: "Structured biography for a person."
)

add_field(p1, key: "full_name",     type: "string")
add_field(p1, key: "age",           type: "integer")
add_field(p1, key: "profession",    type: "string")
add_field(p1, key: "hobbies",       type: "array",  item_type: "string")
add_field(p1, key: "personality",   type: "enum",   enum_values: "introverted,extroverted,ambiverted")

# =========================================================
# 3. Product Description
# =========================================================

p2 = StructuredSchema.create!(
  name: "Product Description",
  openai_name: "ProductDescription",
  model: "gpt-5.1",
  description: "Describes an item for sale."
)

add_field(p2, key: "title",         type: "string")
add_field(p2, key: "category",      type: "string")
add_field(p2, key: "price_usd",     type: "float")
add_field(p2, key: "condition",     type: "enum", enum_values: "new,used,refurbished")
add_field(p2, key: "features",      type: "array", item_type: "string")

# =========================================================
# 4. Music Track Metadata
# =========================================================

m2 = StructuredSchema.create!(
  name: "Music Track Metadata",
  openai_name: "MusicTrackMetadata",
  model: "gpt-5.1",
  description: "Metadata for audio/music tracks."
)

add_field(m2, key: "track_name",     type: "string")
add_field(m2, key: "artist",         type: "string")
add_field(m2, key: "bpm",            type: "integer")
add_field(m2, key: "genre",          type: "enum", enum_values: "hiphop,rock,pop,ambient,edm")
add_field(m2, key: "moods",          type: "array", item_type: "string")

# =========================================================
# 5. Book Summary
# =========================================================

b1 = StructuredSchema.create!(
  name: "Book Summary",
  openai_name: "BookSummary",
  model: "gpt-5.1",
  description: "Summaries for books."
)

add_field(b1, key: "title",          type: "string")
add_field(b1, key: "author",         type: "string")
add_field(b1, key: "summary",        type: "string")
add_field(b1, key: "rating",         type: "float")
add_field(b1, key: "themes",         type: "array", item_type: "string")

# =========================================================
# 6. Location Info
# =========================================================

l1 = StructuredSchema.create!(
  name: "Location Info",
  openai_name: "LocationInfo",
  model: "gpt-5.1",
  description: "Geographical location description."
)

add_field(l1, key: "city",           type: "string")
add_field(l1, key: "country",        type: "string")
add_field(l1, key: "population",     type: "integer")
add_field(l1, key: "climate",        type: "enum", enum_values: "tropical,temperate,dry,continental,polar")
add_field(l1, key: "landmarks",      type: "array", item_type: "string")

# =========================================================
# 7. Video Metadata
# =========================================================

v1 = StructuredSchema.create!(
  name: "Video Metadata",
  openai_name: "VideoMetadata",
  model: "gpt-5.1",
  description: "Metadata for online video content."
)

add_field(v1, key: "title",          type: "string")
add_field(v1, key: "duration_sec",   type: "integer")
add_field(v1, key: "resolution",     type: "string")
add_field(v1, key: "tags",           type: "array", item_type: "string")
add_field(v1, key: "category",       type: "enum", enum_values: "news,education,entertainment,gaming,vlog")

# =========================================================
# 8. Science Experiment Spec
# =========================================================

sci = StructuredSchema.create!(
  name: "Science Experiment Spec",
  openai_name: "ScienceExperimentSpec",
  model: "gpt-5.1",
  description: "Field list for describing science experiments."
)

add_field(sci, key: "title",         type: "string")
add_field(sci, key: "objective",     type: "string")
add_field(sci, key: "materials",     type: "array", item_type: "string")
add_field(sci, key: "difficulty",    type: "enum", enum_values: "easy,medium,hard")
add_field(sci, key: "estimated_time_minutes", type: "integer")

# =========================================================
# 9. Pet Description
# =========================================================

pet = StructuredSchema.create!(
  name: "Pet Description",
  openai_name: "PetDescription",
  model: "gpt-5.1",
  description: "Describes pets such as dogs, cats, reptiles."
)

add_field(pet, key: "animal_type",     type: "string")
add_field(pet, key: "name",            type: "string")
add_field(pet, key: "age_years",       type: "integer")
add_field(pet, key: "likes",           type: "array", item_type: "string")
add_field(pet, key: "temperament",     type: "enum", enum_values: "friendly,shy,aggressive,relaxed,adventurous")

# =========================================================
# 10. Generic Agent Output
# =========================================================

g1 = StructuredSchema.create!(
  name: "Generic Agent Output",
  openai_name: "GenericAgentOutput",
  model: "gpt-5.1",
  description: "Generic schema for arbitrary structured AI output."
)

add_field(g1, key: "title",           type: "string")
add_field(g1, key: "description",     type: "string")
add_field(g1, key: "score",           type: "float")
add_field(g1, key: "tags",            type: "array", item_type: "string")

puts "Done!"
