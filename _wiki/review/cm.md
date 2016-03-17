

> This overlaps with the services catalog. Also think the MS(F) are more or less deprecated?
 
Configuration Admin is a service which allows configuration information
to be passed into components in order to initialise them, without having
a dependency on where or how that configuration information is stored.
[Felix](Felix "wikilink") uses Configuration Admin to serve the contents
of the `config` directory to bundles, but configuration could easily
come from other sources (e.g. LDAP, properties, environment variables
etc.)

Basic operation - Managed service
---------------------------------

A component indicates to a configuration admin service that it is
willing to receive configuration data by registering a *ManagedService*
interface implementation in the framework service registry. The service
must contain a service property value for the service PID (persistent
identity, a framework constant).

A configuration service admin implementation will look-up and track
service registrations of the ManagedService interface and call the
*updated()* method on the interface with the configuration data for the
specific PID. This configuration data may be null in case the
configuration admin service doesn't have configuration data for the PID.

The interaction is indicated in the following figure (taken from the
OSGi compendium specification v4.2): ![Configuration admin interaction
diagram.](config_admin_interaction.png "fig:Configuration admin interaction diagram.")

In code:

    ...
    class Sample implements ManagedService {
        private ServiceRegistration service;

        private Dictionary defaults() {
            Dictionary defaults = new Hashtable();
            defaults.put("value1", new Integer(123));
            return defaults;
        }
        
        private void addPid(Dictionary config) {
            config.put(Constants.SERVICE_PID, "my.sample.config");
        }

        public void start(BundleContext context) throws Exception {
            Dictionary properties = defaults();
            addPid(properties);
            service = context.registerService(ManagedService.class.getName(),
                this, properties);
        }
        
        public void updated(Dictionary config) {
            if (config == null) { 
                 // Admin doesn't have configuration data
                config = defaults();   // Example: load the defaults.
            }
            else {
                addPid(config);   // Need to add the PID to the passed configuration
            }
            // Do with the configuration what we want.
        }
    }

Basic operation - Managed service factory
-----------------------------------------

TBD.

<Category:Service>

