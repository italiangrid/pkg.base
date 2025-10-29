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
    
    stage('build base images') {
      steps {
        parallel (
          "almalinux9base" : { build_image('rpm', 'almalinux9base') }
        )
      }
    }
    stage('build parallel images'){
      steps {
        parallel (
          "almalinux9java8"  : { build_image('rpm', 'almalinux9java8') },
          "almalinux9java11" : { build_image('rpm', 'almalinux9java11') },
          "almalinux9java17" : { build_image('rpm', 'almalinux9java17') }
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
