#
# Locales: Co-Heyting algebras
#
# Implementations
#

##
InstallGlobalFunction( ADD_COMMON_METHODS_FOR_COHEYTING_ALGEBRAS,
  function( coheyting_algebra )
    
    SetIsCoCartesianCoclosedCategory( coheyting_algebra, true );
    
    SetIsStrictMonoidalCategory( coheyting_algebra, true );
    
    ADD_COMMON_METHODS_FOR_LATTICES( coheyting_algebra );
    
    ## The cocartesian monoidal structure
    
    ## The coclosedness of the cocartesian monoidal structure
    
    ## Warning:
    ## Do not add it to ADD_COMMON_METHODS_FOR_LATTICES
    ## as it will violate the symmetry between products and coproducts
    
    ##
    AddAssociatorRightToLeftOfCoproductsWithGivenCoproducts( coheyting_algebra,
      function( s, a, b, c, r )
        
        return UniqueMorphism( s, r );
        
    end );
    
    ##
    AddAssociatorLeftToRightOfCoproductsWithGivenCoproducts( coheyting_algebra,
      function( s, a, b, c, r )
        
        return UniqueMorphism( s, r );
        
    end );
    
    ## Note:
    ## The dual of a closed cartesian category is
    ## NOT a closed cocartesian category (such is equivalent to a terminal category)
    ## but a co-closed cocartesian category!
    
    ## The duals
    
    ##
    AddDualOnObjects( coheyting_algebra,
      function( A )
        
        return InternalHomOnObjects( A, TerminalObject( coheyting_algebra ) );
        
    end );
    
    ##
    AddDualOnMorphismsWithGivenDuals( coheyting_algebra,
      function( B_, u, A_ )
        
        return InternalHomOnMorphismsWithGivenInternalHoms( B_, u, IdentityMorphism( TerminalObject( coheyting_algebra ) ), A_ );
        
    end );
    
    ##
    AddMorphismToBidualWithGivenBidual( coheyting_algebra,
      function( A, B )
        
        return UniqueMorphism( A, B );
        
    end );
    
end );