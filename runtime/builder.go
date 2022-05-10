package runtime

import (
	"encoding/json"
	"io"

	"github.com/tendermint/tendermint/libs/log"
	dbm "github.com/tendermint/tm-db"

	"github.com/cosmos/cosmos-sdk/baseapp"
	"github.com/cosmos/cosmos-sdk/version"
)

// AppBuilder is a type that is injected into a container by the runtime module
// (as *AppBuilder) which can be used to create an app which is compatible with
// the existing app.go initialization conventions.
type AppBuilder struct {
	app *App
}

// DefaultGenesis returns a default genesis from the registered
// AppModuleBasic's.
func (a *AppBuilder) DefaultGenesis() map[string]json.RawMessage {
	return a.app.privateState.basicManager.DefaultGenesis(a.app.privateState.cdc)
}

// Build builds an *App instance.
func (a *AppBuilder) Build(logger log.Logger, db dbm.DB, traceStore io.Writer, baseAppOptions ...func(*baseapp.BaseApp)) *App {
	for _, option := range a.app.baseAppOptions {
		baseAppOptions = append(baseAppOptions, option)
	}
	bApp := baseapp.NewBaseApp(a.app.config.AppName, logger, db, baseAppOptions...)
	bApp.SetCommitMultiStoreTracer(traceStore)
	bApp.SetVersion(version.Version)
	bApp.SetInterfaceRegistry(a.app.privateState.interfaceRegistry)
	bApp.MountStores(a.app.privateState.storeKeys...)
	bApp.SetTxHandler(a.app.txHandler)

	a.app.BaseApp = bApp
	return a.app
}
