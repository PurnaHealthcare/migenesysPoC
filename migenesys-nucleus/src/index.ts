/// <reference types="node" />
import { CommandHandler } from './commands/command_handler.js';
import { QueryHandler } from './queries/query_handler.js';

async function runDemo() {
    console.log('🚀 Starting migenesys-nucleus Demo...\n');

    const commandHandler = new CommandHandler();
    const queryHandler = new QueryHandler();

    // 1. Handle a Command
    console.log('--- Step 1: Handling Command ---');
    const startJourneyCommand = {
        type: 'StartJourney',
        userId: 'user-123',
        data: { title: 'My Health Journey' }
    };

    const event = await commandHandler.handle(startJourneyCommand);
    console.log('Command processed, event generated:', JSON.stringify(event, null, 2));
    console.log('');

    // 2. Project the event into the Read Model
    console.log('--- Step 2: Projecting Event ---');
    queryHandler.project(event);
    console.log('Event projected into read model.\n');

    // 3. Query the Read Model
    console.log('--- Step 3: Querying Journeys ---');
    const journeys = queryHandler.getJourneys();
    console.log('Current Journeys:', JSON.stringify(journeys, null, 2));

    console.log('\n✅ migenesys-nucleus Demo completed successfully.');
}

runDemo().catch(err => {
    console.error('❌ Demo failed:', err);
    process.exit(1);
});
