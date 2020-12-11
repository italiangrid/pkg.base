#!/usr/bin/env groovy

def build_image(dirname, tags){
    deleteDir()
    unstash "source"

    dir("${dirname}"){
      withDockerRegistry([ credentialsId: "dockerhub-enrico", url: "" ]) {
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
        parallel(
          "centos7"   : { build_image('rpm', 'centos7') },
          "centos8"   : { build_image('rpm', 'centos8') },
          "ubuntu1604": { build_image('deb', 'ubuntu1604') } ,
          "ubuntu1804": { build_image('deb', 'ubuntu1804') }
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
