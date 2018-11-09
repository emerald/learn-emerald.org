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


--------------------------------------------------------------------------------

docsPath :: FilePath -> FilePath
docsPath path =
  takeDirectory path </>
    ((tail . dropWhile (/= '-') . takeBaseName) path) <.> "html"

main :: IO ()
main = hakyll $ do
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "*.png" $ do
        route   idRoute
        compile copyFileCompiler

    match "*.svg" $ do
        route   idRoute
        compile copyFileCompiler

    match "*.ico" $ do
        route   idRoute
        compile copyFileCompiler

    match "*.xml" $ do
        route   idRoute
        compile copyFileCompiler

    match "*.webmanifest" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match "docs/*" $ do
        route $ customRoute $ docsPath . toFilePath
        compile $ pandocCompiler
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
