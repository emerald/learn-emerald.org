--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll
import           System.FilePath
  ( takeDirectory
  , takeBaseName
  , (</>)
  , (<.>)
  )
import           Text.Pandoc.Options

--------------------------------------------------------------------------------

docsPath :: FilePath -> FilePath
docsPath path =
  takeDirectory path </>
    ((tail . dropWhile (/= '-') . takeBaseName) path) <.> "html"

copyGlobs = foldl1 (.||.)
  [ "images/*"
  , "css/*"
  , "js/*"
  , "*.png"
  , "*.svg"
  , "*.ico"
  , "*.xml"
  , "*.webmanifest"
  ]

customPandocCompiler :: Compiler (Item String)
customPandocCompiler =
    let moreReaderExtensions = [Ext_raw_html]
        readerOptions = defaultHakyllReaderOptions {
          readerExtensions =
            readerExtensions defaultHakyllReaderOptions <>
            extensionsFromList moreReaderExtensions
        }
        writerOptions = defaultHakyllWriterOptions
    in pandocCompilerWith readerOptions writerOptions

main :: IO ()
main = hakyll $ do
    match copyGlobs $ do
        route   idRoute
        compile copyFileCompiler

    match "docs/*" $ do
        route $ customRoute $ docsPath . toFilePath
        compile $ customPandocCompiler
            >>= loadAndApplyTemplate "templates/article.html" artcileCtx
            >>= loadAndApplyTemplate "templates/default.html" artcileCtx
            >>= relativizeUrls

    create ["docs.html"] $ do
        route idRoute
        compile $ do
            docs <- loadAll "docs/*"
            let docsCtx =
                    listField "docs" artcileCtx (return docs) `mappend`
                    constField "title" "Docs"                         `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/docs.html" docsCtx
                >>= loadAndApplyTemplate "templates/default.html" docsCtx
                >>= relativizeUrls


    match "index.html" $ do
        route idRoute
        compile $ do
            let indexCtx =
                    constField "title" "Home" `mappend`
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "*.rst" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" artcileCtx
            >>= relativizeUrls


    match "templates/*" $ compile templateBodyCompiler


--------------------------------------------------------------------------------
artcileCtx :: Context String
artcileCtx =
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext
