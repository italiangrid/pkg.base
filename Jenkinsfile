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
          "centos7"   : { build_image('rpm', 'centos7') },
          "centos7java11"   : { build_image('rpm', 'centos7java11') },
          "centos7java17"   : { build_image('rpm', 'centos7java17') },
          "almalinux8java17"   : { build_image('rpm', 'almalinux8java17') },
          "centos9"   : { build_image('rpm', 'centos9') },
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
}
