--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll


--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match "docs/*" $ do
        route $ setExtension "html"
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


    match "index.rst" $ do
        route $ setExtension "html"
        compile $ do
            let indexCtx =
                    constField "title" "Home" `mappend`
                    defaultContext

            pandocCompiler
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateBodyCompiler


--------------------------------------------------------------------------------
artcileCtx :: Context String
artcileCtx =
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext
