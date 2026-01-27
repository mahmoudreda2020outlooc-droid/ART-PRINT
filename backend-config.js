// Appwrite Configuration
const APPWRITE_CONFIG = {
    ENDPOINT: 'https://cloud.appwrite.io/v1', // Standard Appwrite Cloud Endpoint
    PROJECT_ID: '697121c70024e4e94ac3',
    DATABASE_ID: '6971223f003e5f162359',
    COLLECTION_ID: 'products',
    FEEDBACK_COLLECTION_ID: 'feedback', // Create this collection in Appwrite with permissions: role:all (create)
    BUCKET_ID: 'product_images'
};

// Export for usage in other files
if (typeof module !== 'undefined') {
    module.exports = APPWRITE_CONFIG;
}
