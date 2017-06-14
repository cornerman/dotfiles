// maxErrors := 3

// ctrl+c does not quit
cancelable in Global := true

triggeredMessage in ThisBuild := Watched.clearWhenTriggered

// also watch managed library dependencies
watchSources <++= (managedClasspath in Compile) map { cp => cp.files }

// import com.softwaremill.clippy.ClippySbtPlugin._ // needed in global configuration only
// clippyColorsEnabled := true

// import com.scalapenos.sbt.prompt.SbtPrompt.autoImport._
// promptTheme := com.scalapenos.sbt.prompt.PromptThemes.ScalapenosTheme

import org.ensime.EnsimeKeys._

ensimeIgnoreMissingDirectories := true
