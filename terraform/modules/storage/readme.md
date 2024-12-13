Explanation:

    google_storage_bucket "US": Creates one bucket, one in the US and makes it public via 'allUsers' IAM principle.

    name: The bucket name must be globally unique, so we're using a combination of a prefix and the project ID to ensure uniqueness. I will use my project ID to create these first, then you can use yours.

    location: Specifies the region for the bucket.

    uniform_bucket_level_access: Enables uniform bucket-level access for simpler IAM management (recommended for new buckets).

    website: Configures the bucket to serve static website content, setting the main_page_suffix and not_found_page.

    google_storage_bucket_object "object_us" & "object_europe": This uploads a file to each bucket named image.png.
