addSbtPlugin("org.ensime" % "sbt-ensime" % "1.12.13")

addSbtPlugin("io.get-coursier" % "sbt-coursier" % "1.0.0-RC3") // better dependency fetcher

addSbtPlugin("net.virtual-void" % "sbt-dependency-graph" % "0.8.2")

// addSbtPlugin("com.softwaremill.clippy" % "plugin-sbt" % "0.5.3")

addSbtPlugin("com.oradian.sbt" % "sbt-sh" % "0.1.0")

addSbtPlugin("com.github.cuzfrog" % "sbt-tmpfs" % "0.2.1")

addSbtPlugin("com.orrsella" % "sbt-stats" % "1.0.5")
addSbtPlugin("com.timushev.sbt" % "sbt-updates" % "0.3.1")
addSbtPlugin("com.scalapenos" % "sbt-prompt" % "1.0.0")

resolvers += Resolver.bintrayIvyRepo("duhemm", "sbt-plugins")
addSbtPlugin("org.duhemm" % "sbt-errors-summary" % "0.2.0")
