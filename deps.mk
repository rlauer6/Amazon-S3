# ./lib/Amazon/S3.pm.in
./lib/Amazon/S3.pm: \
    ./lib/Amazon/S3/Bucket.pm \
    ./lib/Amazon/S3/BucketV2.pm \
    ./lib/Amazon/S3/Constants.pm \
    ./lib/Amazon/S3/Logger.pm \
    ./lib/Amazon/S3/Signature/V4.pm \
    ./lib/Amazon/S3/Util.pm

# ./lib/Amazon/S3/Bucket.pm.in
./lib/Amazon/S3/Bucket.pm: \
    ./lib/Amazon/S3/Constants.pm \
    ./lib/Amazon/S3/Util.pm

# ./lib/Amazon/S3/BucketV2.pm.in
./lib/Amazon/S3/BucketV2.pm: \
    ./lib/Amazon/S3/Bucket.pm \
    ./lib/Amazon/S3/Constants.pm \
    ./lib/Amazon/S3/Util.pm

# ./lib/Amazon/S3/Logger.pm.in
./lib/Amazon/S3/Logger.pm: \
    ./lib/Amazon/S3/Constants.pm

# ./lib/Amazon/S3/Util.pm.in
./lib/Amazon/S3/Util.pm: \
    ./lib/Amazon/S3/Constants.pm

