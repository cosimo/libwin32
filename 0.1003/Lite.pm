package Win32::OLE;

sub _croak { require Carp; Carp::croak(@_) }

unless (defined &Dispatch) {
    DynaLoader::boot_DynaLoader('DynaLoader') unless defined(&DynaLoader::dl_load_file);
    my $file;
    foreach my $dir (@INC) {
	my $try = "$dir/auto/Win32/OLE/OLE.dll";
	last if $file = (-f $try && $try);
    }
    _croak("Can't locate loadable object for module Win32::OLE in \@INC (\@INC contains: @INC)")
	unless $file;	# wording similar to error from 'require'

    my $libref = DynaLoader::dl_load_file($file, 0) or
	_croak("Can't load '$file' for module Win32::OLE: ".DynaLoader::dl_error()."\n");

    my $boot_symbol_ref = DynaLoader::dl_find_symbol($libref, "boot_Win32__OLE") or
         _croak("Can't find 'boot_Win32__OLE' symbol in $file\n");

    my $xs = DynaLoader::dl_install_xsub("Win32::OLE::bootstrap", $boot_symbol_ref, $file);
    &$xs('Win32::OLE');
}

$Warn = 1;

sub CP_ACP   {0;}     # ANSI codepage
sub CP_OEMCP {1;}     # OEM codepage
sub CP_MACCP {2;}
sub CP_UTF7  {65000;}
sub CP_UTF8  {65001;}

sub DISPATCH_METHOD          {1;}
sub DISPATCH_PROPERTYGET     {2;}
sub DISPATCH_PROPERTYPUT     {4;}
sub DISPATCH_PROPERTYPUTREF  {8;}

sub COINIT_MULTITHREADED      {0;}  # Default
sub COINIT_APARTMENTTHREADED  {2;}  # Use single threaded apartment model

# Bogus COINIT_* values to indicate special cases:
sub COINIT_OLEINITIALIZE      {-1;} # Use OleInitialize instead of CoInitializeEx
sub COINIT_ALREADYINITIALIZED {-2;} # COM is already initialied; don't do it again


# CreateObject is defined here only because it is documented in the
# "Learning Perl on Win32 Systems" Gecko book. Please use Win32::OLE->new().
sub CreateObject {
    if (ref($_[0]) && UNIVERSAL::isa($_[0],'Win32::OLE')) {
	$AUTOLOAD = 'CreateObject';
	goto &AUTOLOAD;
    }

    $_[1] = Win32::OLE->new($_[0]);
    return defined $_[1];
}

sub LastError {
    unless (defined $_[0]) {
	# Win32::OLE::LastError() will always return $Win32::OLE::LastError
	return $LastError;
    }

    if (ref($_[0]) && UNIVERSAL::isa($_[0],'Win32::OLE')) {
	$AUTOLOAD = 'LastError';
	goto &AUTOLOAD;
    }

    #no strict 'refs';
    my $LastError = "$_[0]::LastError";
    $$LastError = $_[1] if defined $_[1];
    return $$LastError;
}

sub Invoke {
    my ($self, $method, @args) = @_;
    my $retval;
    $self->Dispatch($method, $retval, @args);
    return $retval;
}

sub SetProperty {
    my ($self, $method, @args) = @_;
    my $retval;
    my $wFlags = DISPATCH_PROPERTYPUT;
    if (@args) {
	# If the value is an object then it must be set by reference!
	my $value = $args[scalar(@args)-1];
	if (UNIVERSAL::isa($value, 'Win32::OLE')) {
	    $wFlags = DISPATCH_PROPERTYPUTREF;
	}
	elsif (UNIVERSAL::isa($value,'Win32::OLE::Variant')) {
	    my $type = $value->Type;
	    # VT_DISPATCH and VT_UNKNOWN represent COM objects
	    $wFlags = DISPATCH_PROPERTYPUTREF if $type == 9 || $type == 13;
	}
    }
    $self->Dispatch([$wFlags, $method], $retval, @args);
    return $retval;
}

sub AUTOLOAD {
    my $self = shift;
    my $retval;
    $AUTOLOAD =~ s/.*:://o;
    _croak("Cannot autoload class method \"$AUTOLOAD\"") 
      unless ref($self) && UNIVERSAL::isa($self, 'Win32::OLE');
    my $success = $self->Dispatch($AUTOLOAD, $retval, @_);
    unless (defined $success || ($^H & 0x200)) {
	# Retry default method if C<no strict 'subs';>
	$self->Dispatch(undef, $retval, $AUTOLOAD, @_);
    }
    return $retval;
}

sub in {
    my @res;
    while (@_) {
	my $this = shift;
	if (UNIVERSAL::isa($this, 'Win32::OLE')) {
	    push @res, Win32::OLE::Enum->All($this);
	}
	elsif (ref($this) eq 'ARRAY') {
	    push @res, @$this;
	}
	else {
	    push @res, $this;
	}
    }
    return @res;
}

sub valof {
    my $arg = shift;
    if (UNIVERSAL::isa($arg, 'Win32::OLE')) {
	require Win32::OLE::Variant;
	my ($class) = overload::StrVal($arg) =~ /^([^=]+)=/;
	#no strict 'refs';
	local $Win32::OLE::CP = ${$class."::CP"};
	local $Win32::OLE::LCID = ${$class."::LCID"};
	#use strict 'refs';
	# VT_EMPTY variant for return code
	my $variant = Win32::OLE::Variant->new;
	$arg->Dispatch(undef, $variant);
	return $variant->Value;
    }
    $arg = $arg->Value if UNIVERSAL::can($arg, 'Value');
    return $arg;
}

sub with {
    my $object = shift;
    while (@_) {
	my $property = shift;
	$object->{$property} = shift;
    }
}

########################################################################

package Win32::OLE::Tie;

# Only retry default method under C<no strict 'subs';>

sub FETCH {
    my ($self,$key) = @_;
    $self->Fetch($key, !($^H & 0x200));
}

sub STORE {
    my ($self,$key,$value) = @_;
    $self->Store($key, $value, !($^H & 0x200));
}

1;
