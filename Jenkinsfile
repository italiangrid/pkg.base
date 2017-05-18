pipeline {
  agent none
  
  options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
    timeout(time: 1, unit: 'HOURS')
  }
  
  triggers {
    cron('@daily')
  }

  stages {
    stage('prepare'){
      agent { label 'generic' }
      steps {
        checkout scm
        stash name: "source", includes: "**"
      }
    }
    
    stage('build images'){
      steps {
        parallel(
          "centos6": {
            node('docker'){
              unstash "source"
              dir('rpm') {
                withEnv(["tags=centos6"]){
                  sh "sh build-images.sh"
                  sh "sh push-images.sh"
                }
              }
            }
          },
          "centos7": {
            node('docker'){
              unstash "source"
              dir('rpm') {
                withEnv(["tags=centos7"]){
                  sh "sh build-images.sh"
                  sh "sh push-images.sh"
                }
              }
            }
          },
          "rawhide": {
            node('docker'){
              unstash "source"
              dir('rpm') {
                withEnv(["tags=rawhide"]){
                  sh "sh build-images.sh"
                  sh "sh push-images.sh"
                }
              }
            }
          },
          "ubuntu1604": {
            node('docker'){
              unstash "source"
              dir('deb'){
                sh "sh build-images.sh"
                sh "sh push-images.sh"
              }
            }
          }
          )
      }
    }
  }
  
  post {
    failure {
      slackSend color: 'danger', message: "${env.JOB_NAME} - #${env.BUILD_NUMBER} Failure (<${env.BUILD_URL}|Open>)"
    }
    changed {
      script{
        if('SUCCESS'.equals(currentBuild.result)) {
          slackSend color: 'good', message: "${env.JOB_NAME} - #${env.BUILD_NUMBER} Back to normal (<${env.BUILD_URL}|Open>)"
        }
      }
    }
  }
}
