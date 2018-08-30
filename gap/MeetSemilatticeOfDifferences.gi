#
# Locales: MeetSemilatticeOfDifferences
#
# Implementations
#

##
InstallMethod( MeetSemilatticeOfDifferences,
        "for a CAP category",
        [ IsCapCategory and IsThinCategory ],
        
  function( P )
    local name, D, L;
    
    name := "The meet-semilattice of differences of ";
    
    name := Concatenation( name, Name( P ) );
    
    D := CreateCapCategory( name );
    
    D!.UnderlyingCategory := P;
    
    AddObjectRepresentation( D, IsObjectInMeetSemilatticeOfDifferences );
    
    AddMorphismRepresentation( D, IsMorphismInMeetSemilatticeOfDifferences );
    
    ADD_COMMON_METHODS_FOR_MEET_SEMILATTICES( D );
    
    ##
    AddIsWellDefinedForObjects( D,
      function( A )
        local u;
        
        u := MorphismOfUnderlyingLattice( A );
        
        return IsWellDefinedForObjects( Source( u ) ) and IsWellDefinedForObjects( Range( u ) );
        
    end );
    
    ##
    AddIsWellDefinedForMorphisms( D,
      function( u )
        local uS, uT, A, Ap, B, Bp;
        
        uS := MorphismOfUnderlyingLattice( Source( u ) );
        uT := MorphismOfUnderlyingLattice( Range( u ) );
        
        A := Range( uS );
        Ap := Source( uS );
        
        B := Range( uT );
        Bp := Source( uT );
        
        return IsSubset( Coproduct( Ap, B ), A ) and IsSubset( Ap, DirectProduct( A, Bp ) );
        
    end );
    
    L := ListInstalledOperationsOfCategory( P );
    
    if not ( HasIsSkeletalCategory( P ) and IsSkeletalCategory( P ) ) then
        Error( "the category is not known to be skeletal\n" );
    elif not ( "DirectProduct" in L and "Coproduct" in L ) then
        Error( "the category does not seem to be a lattice\n" );
    fi;
    
    ##
    AddTerminalObject( D,
      function( arg )
        local T, I;
        
        T := TerminalObject( D!.UnderlyingCategory );
        I := InitialObject( D!.UnderlyingCategory );
        
        return AsFormalDifference( T, I );
        
    end );
    
    ##
    AddInitialObject( D,
      function( arg )
        local I;
        
        I := InitialObject( D!.UnderlyingCategory );
        
        return AsFormalDifference( IdentityMorphism( I ) );
        
    end );
    
    ##
    AddDirectProduct( D,
      function( L )
        local T, S;
        
        L := List( L, MorphismOfUnderlyingLattice );
        
        T := DirectProduct( List( L, Range ) );
        S := Coproduct( List( L, Source ) );
        
        return T - S;
        
    end );
    
    Finalize( D );
    
    return D;
    
end );

##
InstallMethod( AsFormalDifference,
        "for a morphism in a thin category",
        [ IsMorphismInThinCategory ],
        
  function( u )
    local A, D;
    
    A := rec( );

    D := MeetSemilatticeOfDifferences( CapCategory( u ) );
    
    ObjectifyObjectForCAPWithAttributes( A, D,
            PreMorphismOfUnderlyingLattice, u
            );
    
    Assert( 4, IsWellDefined( A ) );
    
    return A;
    
end );

##
InstallMethod( \-,
        "for two objects in a thin category",
        [ IsObjectInThinCategory, IsObjectInThinCategory ],
        
  function( A, B )
    
    return AsFormalDifference( UniqueMorphism( B, A ) );
    
end );

##
InstallMethod( \-,
        "for an object in a thin category and the zero integer",
        [ IsObjectInThinCategory, IsInt and IsZero ],
        
  function( A, B )
    
    return A - InitialObject( CapCategory( A ) );
    
end );

##
InstallMethod( AdditiveInverseMutable,
        "for an object in a thin category",
        [ IsObjectInThinCategory ],
        
  function( A )
    
    return TerminalObject( CapCategory( A ) ) - A;
    
end );

##
InstallMethod( AsFormalDifferenceOfNormalizedMorphism,
        "for a morphism in a thin category",
        [ IsMorphismInThinCategory ],
        
  function( u )
    local A, D;
    
    A := rec( );

    D := MeetSemilatticeOfDifferences( CapCategory( u ) );
    
    ObjectifyObjectForCAPWithAttributes( A, D,
            NormalizedMorphismOfUnderlyingHeytingAlgebra, u
            );
    
    Assert( 4, IsWellDefined( A ) );
    
    return A;
    
end );

##
InstallMethod( NormalizedMorphismOfUnderlyingHeytingAlgebra,
        "for an object in a meet-semilattice of formal differences",
        [ IsObjectInMeetSemilatticeOfDifferences ],
        
  function( A )
    local u, S, T, L, H;
    
    u := MorphismOfUnderlyingLattice( A );
    
    S := Source( u );
    T := Range( u );
    
    L := CapCategory( u );
    
    H := InternalHomOnObjects( T, S );
    
    if HasIsCartesianClosedCategory( L ) and IsCartesianClosedCategory( L ) then
        
        return UniqueMorphism( H, Coproduct( H, T ) );
        
    elif HasIsCocartesianCoclosedCategory( L ) and IsCocartesianCoclosedCategory( L ) then
        
        return UniqueMorphism( DirectProduct( S, H ), H );
        
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( MorphismOfUnderlyingLattice,
        "for an object in a meet-semilattice of formal differences",
        [ IsObjectInMeetSemilatticeOfDifferences ],
        
  PreMorphismOfUnderlyingLattice );

##
InstallMethod( MorphismOfUnderlyingLattice,
        "for an object in a meet-semilattice of formal differences",
        [ IsObjectInMeetSemilatticeOfDifferences and HasNormalizedMorphismOfUnderlyingHeytingAlgebra ],
        
  NormalizedMorphismOfUnderlyingHeytingAlgebra );

##
InstallMethod( MorphismOfUnderlyingLattice,
        "for an object in a meet-semilattice of formal differences",
        [ IsObjectInMeetSemilatticeOfDifferences and HasStandardMorphismOfUnderlyingHeytingAlgebra ],
        
  StandardMorphismOfUnderlyingHeytingAlgebra );

##
InstallMethod( \*,
        "for an object in a thin category and an object in a meet-semilattice of formal differences",
        [ IsObjectInThinCategory, IsObjectInMeetSemilatticeOfDifferences ],
        
  function( A, B )
    
    if IsObjectInMeetSemilatticeOfDifferences( A ) then
        TryNextMethod( );
    fi;
    
    return ( A - 0 ) * B;
    
end );

##
InstallMethod( \*,
        "for an object in a meet-semilattice of formal differences and an object in a thin category",
        [ IsObjectInMeetSemilatticeOfDifferences, IsObjectInThinCategory ],
        
  function( A, B )
    
    if IsObjectInMeetSemilatticeOfDifferences( B ) then
        TryNextMethod( );
    fi;
    
    return A * ( B - 0 );
    
end );

##
InstallMethod( \=,
        "for an object in a thin category and an object in a meet-semilattice of formal differences",
        [ IsObjectInThinCategory, IsObjectInMeetSemilatticeOfDifferences ],
        
  function( A, B )
    
    if IsObjectInMeetSemilatticeOfDifferences( A ) then
        TryNextMethod( );
    fi;
    
    return ( A - 0 ) = B;
    
end );

##
InstallMethod( \=,
        "for an object in a meet-semilattice of formal differences and an object in a thin category",
        [ IsObjectInMeetSemilatticeOfDifferences, IsObjectInThinCategory ],
        
  function( A, B )
    
    if IsObjectInMeetSemilatticeOfDifferences( B ) then
        TryNextMethod( );
    fi;
    
    return A = ( B - 0 );
    
end );

##
InstallMethod( Display,
        "for an object in a meet-semilattice of formal differences",
        [ IsObjectInMeetSemilatticeOfDifferences ],
        
  function( A )
    
    Display( MorphismOfUnderlyingLattice( A ) );
    
    Print( "\nA formal difference given by the above morphism\n" );
    
end );
