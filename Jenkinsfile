node {
    checkout scm
    sh 'git submodule update --init' 
    sh 'gradle assemble build buildTar'
    sh 'make'
}
