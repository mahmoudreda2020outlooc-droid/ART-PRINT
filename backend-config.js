// Appwrite Configuration
// WARNING: These IDs are public. Ensure Appwrite permissions are set correctly (Role: "Any" should only have "Read" for products).
const APPWRITE_CONFIG = {
    ENDPOINT: 'https://cloud.appwrite.io/v1', 
    PROJECT_ID: '697121c70024e4e94ac3',
    DATABASE_ID: '6971223f003e5f162359',
    COLLECTION_ID: 'products',
    FEEDBACK_COLLECTION_ID: 'feedback', 
    BUCKET_ID: 'product_images'
};


// Export for usage in other files
if (typeof module !== 'undefined') {
    module.exports = APPWRITE_CONFIG;
}
