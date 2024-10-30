#!/usr/bin/env groovy

def build_image(dirname, tags){
    deleteDir()
    unstash "source"

    dir("${dirname}"){
      withDockerRegistry([ credentialsId: "docker-cnafsoftwaredevel", url: "" ]) {
        sh "tags=${tags} sh build-images.sh"
        sh "tags=${tags} sh push-images.sh"
      }
    }
}

pipeline {

  agent { label 'docker' }
  
  options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
    timeout(time: 3, unit: 'HOURS')
  }
  
  triggers {
    cron('@daily')
  }
  
  stages {
    stage('prepare'){
      steps {
        checkout scm
        stash name: "source", includes: "**"
      }
    }
    
    stage('build images (1)'){
      steps {
        parallel (
          "centos7java8"   : { build_image('rpm', 'centos7java8') },
          "centos7java11"   : { build_image('rpm', 'centos7java11') },
          // "centos7java17"   : { build_image('rpm', 'centos7java17') },
          "almalinux8java8"   : { build_image('rpm', 'almalinux8java8') },
          "almalinux8java17"   : { build_image('rpm', 'almalinux8java17') },
          // "centos9"   : { build_image('rpm', 'centos9') },
          "almalinux9java8"   : { build_image('rpm', 'almalinux9java8') },
          "almalinux9java11"   : { build_image('rpm', 'almalinux9java11') },
          "almalinux9java17"   : { build_image('rpm', 'almalinux9java17') }
        )
      }
    }
    
    stage('result'){
      steps {
        script { currentBuild.result = 'SUCCESS' }
      }
    }
  }

  post {
    failure {
      mattermostSend(message: "${env.JOB_NAME} - ${env.BUILD_NUMBER} has failed (<${env.BUILD_URL}|Open>)", color: "danger")
    }
    changed {
      script{
        if ('SUCCESS'.equals(currentBuild.result)) {
          mattermostSend(message: "${env.JOB_NAME} - ${env.BUILD_NUMBER} Back to normal (<${env.BUILD_URL}|Open>)", color: "good")
        }
      }
    }
  }
}
