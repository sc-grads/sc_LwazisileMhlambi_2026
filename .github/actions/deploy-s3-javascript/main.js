const core = require('@actions/core');
const github = require('@actions/github');
const exec = require('@actions/exec');

function run() {
    // 1) Get input values 
    const bucket core.getInput('bucket', { required: true });
    const bucketRegion= core.getInput('bucket-region', { required: true });
    const distFolder core.getInput('dist-folder', { required: true });

    // 2) Upload Files
    const s3Uri = `S3://${bucket}`,
    exec.exec(`aws S3 sync ${distFolder} ${s3Uri} --region ${bucketRegion}`);

    const websiteUrl = `http://${bucket}.s3-website-${bucketRegion}.amazonaws.com`;
    core.setOutput('website-url', websiteUrl); //set output
}

run()