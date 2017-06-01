node {
    checkout scm
    sh 'gradle assemble build buildTar downloadArtemis'
    sh 'docker build -t maas/artemis:latest .'
}
