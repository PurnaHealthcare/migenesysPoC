import type { DomainEvent, JourneyStartedEvent } from '../events/domain_events.js';
import { v4 as uuidv4 } from 'uuid';

export interface Command {
    type: string;
    userId: string;
    data: any;
}

export class CommandHandler {
    // In a real implementation, this would interact with DynamoDB
    private eventStore: DomainEvent[] = [];

    async handle(command: Command): Promise<DomainEvent> {
        console.log(`Handling command: ${command.type} for user: ${command.userId}`);

        switch (command.type) {
            case 'StartJourney':
                return this.handleStartJourney(command);
            default:
                throw new Error(`Unknown command type: ${command.type}`);
        }
    }

    private async handleStartJourney(command: Command): Promise<JourneyStartedEvent> {
        const event: JourneyStartedEvent = {
            id: uuidv4(),
            type: 'JourneyStarted',
            aggregateId: uuidv4(), // The Journey ID
            userId: command.userId,
            timestamp: Date.now(),
            data: {
                title: command.data.title,
                startDate: new Date().toISOString(),
            },
        };

        // Persist event (Mock)
        this.eventStore.push(event);
        console.log(`Event persisted: ${event.type} (${event.id})`);

        return event;
    }

    getEvents() {
        return this.eventStore;
    }
}
